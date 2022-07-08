extends Tower
class_name TCell

func update_upgrade_status() -> void:
	super.update_upgrade_status()
	
	model.main_model_name = "tier1-0"
	if upgrades[0] > upgrades[1] and upgrades[0] > upgrades[2]:
		model.palette["nucl"] = [Color("2e76db"), Color("351c99")]
		model.palette["gun"] = [Color("2e76db"), Color("351c99")]
	if upgrades[1] > upgrades[0] and upgrades[1] > upgrades[2]:
		model.palette["nucl"] = [Color("f5c320"), Color("d9720b")]
		model.palette["gun"] = [Color("f5c320"), Color("d9720b")]
	if upgrades[2] > upgrades[0] and upgrades[2] > upgrades[1]:
		model.palette["nucl"] = [Color("a52cc7"), Color("6121b5")]
		model.palette["gun"] = [Color("a52cc7"), Color("6121b5")]
	
	if upgrade_threshold_met([2, 0, 0]) or upgrade_threshold_met([0, 2, 0]):
		model.main_model_name = "tier2-3"
	if upgrade_threshold_met([0, 0, 2]):
		model.main_model_name = "tier2sur-6"
	
	if upgrade_threshold_met([3, 0, 0]) or upgrade_threshold_met([0, 3, 0]):
		model.main_model_name = "tier3-9"
	if upgrade_threshold_met([3, 0, 2]) or upgrade_threshold_met([0, 3, 2]):
		model.main_model_name = "tier3surs-12"
	if upgrade_threshold_met([0, 0, 3]):
		model.main_model_name = "tier3sur-15"
	
	if upgrade_threshold_met([4, 0, 0]) or upgrade_threshold_met([0, 4, 0]):
		model.main_model_name = "tier4-18"
	if upgrade_threshold_met([4, 0, 2]) or upgrade_threshold_met([0, 4, 2]):
		model.main_model_name = "tier4surs-21"
	if upgrade_threshold_met([0, 0, 4]):
		model.main_model_name = "tier4sur-24"
	
	model.finalize_model()
