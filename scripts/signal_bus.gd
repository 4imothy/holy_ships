extends Node

signal pp_step
signal pp_release
signal vending_sound
signal splash_sound
signal cauldron_success_sound
signal apply_shake
signal increase_health(amount_to_increase)
signal decrease_health(amount_to_decrease)
signal end_game(success: bool)
signal alert_player

signal set_warning_text(mes)
signal stop_warning_text()

signal fire_put_out
