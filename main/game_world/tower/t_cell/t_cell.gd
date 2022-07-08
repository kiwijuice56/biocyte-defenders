extends Tower
class_name TCell

var color_boost: float = 1.35

func update_upgrade_status() -> void:
	super.update_upgrade_status()
	
	model.main_model_name = "tier1-0"
	
	# Calculate the main and secondary path 
	var highest_path: int = 0
	for i in range(len(upgrades)):
		if upgrades[i] > upgrades[highest_path]:
			highest_path = i
	var second_path: int = (highest_path + 1) % len(upgrades)
	for i in range(len(upgrades)):
		if not i == highest_path and upgrades[i] > upgrades[second_path]:
			second_path = i
	
	# Color nucleus as secondary path if at or above tier 3
	if upgrades[second_path] > 0 and upgrades[highest_path] >= 3:
		var boost: float = max(1, color_boost * (upgrades[second_path]-1))
		match second_path:
			0: model.palette["nucl"] = [Color("2e76db") * boost, Color("351c99") * boost]
			1: model.palette["nucl"] = [Color("f5c320") * boost, Color("d9720b") * boost]
			2: model.palette["nucl"] = [Color("a52cc7") * boost, Color("6121b5") * boost]
	elif upgrades[highest_path] >= 1: # Otherwise, color nucleus as main path color
		match highest_path: 
			0: model.palette["nucl"] = [Color("2e76db"), Color("351c99")]
			1: model.palette["nucl"] = [Color("f5c320"), Color("d9720b")]
			2: model.palette["nucl"] = [Color("a52cc7"), Color("6121b5")]
	
	# Update gun color always, as it changes nothing for t cells without guns
	match highest_path:
		0: model.palette["gun"] = [Color("2e76db"), Color("351c99")]
		1: model.palette["gun"] = [Color("f5c320"), Color("d9720b")]
		2: model.palette["gun"] = [Color("a52cc7"), Color("6121b5")]
	
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
