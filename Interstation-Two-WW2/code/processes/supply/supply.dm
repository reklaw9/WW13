var/global/process/supply/supplyProcess

/process/supply

/process/supply/setup()
	name = "supply points"
	schedule_interval = 20 // every 2 seconds
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	supplyProcess = src

/process/supply/fire()
	SCHECK

	if (!map)
		return

	if (german_supplytrain_master)
		german_supplytrain_master.supply_points += map.supply_points_per_tick[GERMAN]
	else
		supply_points[GERMAN] += map.supply_points_per_tick[GERMAN]

	supply_points[SOVIET] += map.supply_points_per_tick[SOVIET]

	// change supply codes every ~13 minutes on average to stop metagaming
	if (prob(1) && prob(25) && !german_supplytrain_master)
		var/original_code = supply_codes[GERMAN]
		supply_codes[GERMAN] = rand(1000,9999)
		for (var/mob/living/carbon/human/H in human_mob_list)
			if (H.original_job && H.original_job.is_officer)
				if (H.original_job.base_type_flag() == GERMAN)
					H.replace_memory(original_code, supply_codes[GERMAN])
		radio2germans("The supply passcode has been changed to [supply_codes[GERMAN]] for security reasons.", "High Command Private Announcements")

	if (prob(1) && prob(25))
		var/original_code = supply_codes[SOVIET]
		supply_codes[SOVIET] = rand(1000,9999)
		for (var/mob/living/carbon/human/H in human_mob_list)
			if (H.original_job && H.original_job.is_officer)
				if (H.original_job.base_type_flag() == SOVIET)
					H.replace_memory(original_code, supply_codes[SOVIET])
		radio2soviets("The supply passcode has been changed to [supply_codes[SOVIET]] for security reasons.", "High Command Private Announcements")
