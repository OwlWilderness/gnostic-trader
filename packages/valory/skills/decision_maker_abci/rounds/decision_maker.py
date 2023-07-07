# -*- coding: utf-8 -*-
# ------------------------------------------------------------------------------
#
#   Copyright 2023 Valory AG
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# ------------------------------------------------------------------------------

"""This module contains the decision-making state of the decision-making abci app."""

from enum import Enum
from typing import Optional, Tuple, cast

from packages.valory.skills.abstract_round_abci.base import (
    CollectSameUntilThresholdRound,
    get_name,
)
from packages.valory.skills.decision_maker_abci.payloads import DecisionMakerPayload
from packages.valory.skills.decision_maker_abci.rounds.base import (
    Event,
    SynchronizedData,
)


class DecisionMakerRound(CollectSameUntilThresholdRound):
    """A round in which the agents decide on the bet's answer."""

    payload_class = DecisionMakerPayload
    synchronized_data_class = SynchronizedData
    done_event = Event.DONE
    none_event = Event.MECH_RESPONSE_ERROR
    no_majority_event = Event.NO_MAJORITY
    selection_key = (
        get_name(SynchronizedData.non_binary),
        get_name(SynchronizedData.vote),
        get_name(SynchronizedData.confidence),
        get_name(SynchronizedData.is_profitable),
    )
    collection_key = get_name(SynchronizedData.participant_to_decision)

    def end_block(self) -> Optional[Tuple[SynchronizedData, Enum]]:
        """Process the end of the block."""
        res = super().end_block()
        if res is None:
            return None

        synced_data, event = cast(Tuple[SynchronizedData, Enum], res)
        if event == Event.DONE and synced_data.non_binary:
            return synced_data, Event.NON_BINARY

        if event == Event.DONE and synced_data.vote is None:
            return synced_data, Event.TIE

        if event == Event.DONE and not synced_data.is_profitable:
            return synced_data, Event.UNPROFITABLE

        return synced_data, event
