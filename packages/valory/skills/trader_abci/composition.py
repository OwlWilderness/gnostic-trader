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

"""This module contains the trader ABCI application."""

from packages.valory.skills.abstract_round_abci.abci_app_chain import (
    AbciAppTransitionMapping,
    chain,
)
from packages.valory.skills.decision_maker_abci.rounds import DecisionMakerAbciApp
from packages.valory.skills.decision_maker_abci.states.final_states import (
    FinishedDecisionMakerRound,
    FinishedWithoutDecisionRound,
)
from packages.valory.skills.decision_maker_abci.states.sampling import SamplingRound
from packages.valory.skills.market_manager_abci.rounds import (
    FailedMarketManagerRound,
    FinishedMarketManagerRound,
    MarketManagerAbciApp,
    UpdateBetsRound,
)
from packages.valory.skills.registration_abci.rounds import (
    AgentRegistrationAbciApp,
    FinishedRegistrationRound,
    RegistrationRound,
)
from packages.valory.skills.reset_pause_abci.rounds import (
    FinishedResetAndPauseErrorRound,
    FinishedResetAndPauseRound,
    ResetAndPauseRound,
    ResetPauseAbciApp,
)
from packages.valory.skills.termination_abci.rounds import BackgroundRound
from packages.valory.skills.termination_abci.rounds import Event as TerminationEvent
from packages.valory.skills.termination_abci.rounds import TerminationAbciApp


abci_app_transition_mapping: AbciAppTransitionMapping = {
    FinishedRegistrationRound: UpdateBetsRound,
    FinishedMarketManagerRound: SamplingRound,
    FailedMarketManagerRound: ResetAndPauseRound,
    FinishedDecisionMakerRound: ResetAndPauseRound,
    FinishedWithoutDecisionRound: ResetAndPauseRound,
    FinishedResetAndPauseRound: UpdateBetsRound,
    FinishedResetAndPauseErrorRound: RegistrationRound,
}

TraderAbciApp = chain(
    (
        AgentRegistrationAbciApp,
        DecisionMakerAbciApp,
        MarketManagerAbciApp,
        ResetPauseAbciApp,
    ),
    abci_app_transition_mapping,
).add_termination(
    background_round_cls=BackgroundRound,
    termination_event=TerminationEvent.TERMINATE,
    termination_abci_app=TerminationAbciApp,
)