-- Removing Unnecessary Columns from hospital_general_information -- 

ALTER TABLE hospital_general_information
DROP COLUMN `Hospital overall rating footnote`, 
DROP COLUMN `MORT Group Measure Count`, 
DROP COLUMN `Count of Facility MORT Measures`,
DROP COLUMN `MORT Group Footnote`, 
DROP COLUMN `Safety Group Measure Count`, 
DROP COLUMN `Count of Facility Safety Measures`, 
DROP COLUMN `Safety Group Footnote`, 
DROP COLUMN `READM Group Measure Count`, 
DROP COLUMN `Count of Facility READM Measures`, 
DROP COLUMN `READM Group Footnote`, 
DROP COLUMN `Pt Exp Group Measure Count`, 
DROP COLUMN `Count of Facility Pt Exp Measures`, 
DROP COLUMN `Pt Exp Group Footnote`, 
DROP COLUMN `TE Group Measure Count`, 
DROP COLUMN `Count of Facility TE Measures`, 
DROP COLUMN `TE Group Footnote`; 

-- Renaming Columns and Changing Data Types for Best Practice -- 

ALTER TABLE hospital_general_information 
RENAME COLUMN `Facility ID` TO facility_id;

ALTER TABLE hospital_general_information
MODIFY COLUMN facility_id char(6);

ALTER TABLE hospital_general_information 
CHANGE `Facility Name` facility_name varchar(74), 
CHANGE `Address` address varchar(100), 
CHANGE `City/Town` city varchar(50), 
CHANGE `State` state char(2), 
CHANGE `ZIP Code` zip_code int, 
CHANGE `County/Parish` county varchar(25), 
CHANGE `Telephone Number` telephone_number varchar(14), 
CHANGE `Hospital Type` hospital_type varchar(255), 
CHANGE `Hospital Ownership` hospital_ownership varchar(255), 
CHANGE `Emergency Services` emergency_services varchar(4), 
CHANGE `Meets criteria for birthing friendly designation` meets_birthing_friendly_designation_criteria varchar(4), 
CHANGE `Hospital overall rating` hospital_overall_rating varchar(100), 
CHANGE `Count of MORT Measures Better` count_MORT_better varchar(100),  
CHANGE `Count of MORT Measures No Different` count_MORT_nodifferent varchar(100),
CHANGE `Count of MORT Measures Worse` count_MORT_worse varchar(100),
CHANGE `Count of Safety Measures Better` count_safety_better varchar(100), 
CHANGE `Count of Safety Measures No Different` count_safety_nodifferent varchar(100), 
CHANGE `Count of Safety Measures Worse` count_safety_worse varchar(100), 
CHANGE `Count of READM Measures Better` count_READM_better varchar(100), 
CHANGE `Count of READM Measures No Different` count_READM_nodifferent varchar(100), 
CHANGE `Count of READM Measures Worse` count_READM_worse varchar(100); 

-- Chaning Yes and No in emergency_services to Boolean -- 

UPDATE hospital_general_information
SET emergency_services = 1
WHERE emergency_services = 'yes';

UPDATE hospital_general_information
SET emergency_services = 0
WHERE emergency_services = 'no'; 

ALTER TABLE hospital_general_information
MODIFY COLUMN emergency_services BOOLEAN; 

-- Changing Y and blanks to Boolean in meets_birthing_friendly_designation_criteria  --

UPDATE hospital_general_information
SET meets_birthing_friendly_designation_criteria = CASE
WHEN meets_birthing_friendly_designation_criteria = 'Y' THEN 1
WHEN meets_birthing_friendly_designation_criteria = '' THEN 0
ELSE meets_birthing_friendly_designation_criteria
END; 

ALTER TABLE hospital_general_information
MODIFY COLUMN meets_birthing_friendly_designation_criteria BOOLEAN; 

-- Changing 'Not Available' to Nulls --  

UPDATE hospital_general_information
SET hospital_overall_rating = CASE
WHEN hospital_overall_rating = 'Not Available' THEN NULL
ELSE hospital_overall_rating 
END; 

UPDATE hospital_general_information
SET count_safety_better = CASE
WHEN count_safety_better = 'Not Available' THEN NULL
ELSE count_safety_better 
END; 

UPDATE hospital_general_information
SET count_safety_nodifferent = CASE
WHEN count_safety_nodifferent = 'Not Available' THEN NULL
ELSE count_safety_nodifferent
END; 

UPDATE hospital_general_information
SET count_safety_worse = CASE
WHEN count_safety_worse = 'Not Available' THEN NULL
ELSE count_safety_worse
END; 

-- Updating Rating columns data type to INT --

ALTER TABLE hospital_general_information
MODIFY COLUMN count_MORT_better INT,
MODIFY COLUMN count_MORT_nodifferent INT, 
MODIFY COLUMN count_MORT_worse INT, 
MODIFY COLUMN count_safety_better INT, 
MODIFY COLUMN count_safety_nodifferent INT, 
MODIFY COLUMN count_safety_worse INT, 
MODIFY COLUMN count_READM_better INT, 
MODIFY COLUMN count_READM_nodifferent INT, 
MODIFY COLUMN count_READM_worse INT;












