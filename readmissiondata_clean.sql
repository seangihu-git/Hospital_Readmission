-- Renaming Columns and Changing Data Types for Best Practice -- 

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
CHANGE `Facility Name` facility_name varchar(74),
CHANGE `Facility ID` facility_id char(6),
CHANGE `State` state char(2),
CHANGE `Measure Name` measure_name varchar(255), 
CHANGE `Excess Readmission Ratio` excess_readmission_ratio decimal(10,4), 
CHANGE `Predicted Readmission Rate` predicted_readmission_rate decimal(10,4), 
CHANGE `Expected Readmission Rate` expected_readmission_rate decimal(10,4);

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
RENAME COLUMN `Start Date` TO start_date, 
RENAME COLUMN `End Date` TO end_date; 

UPDATE fy_2026_hospital_readmissions_reduction_program_hospital
SET start_date = STR_TO_DATE(end_date, '%m/%d/%Y');

UPDATE fy_2026_hospital_readmissions_reduction_program_hospital
SET end_date = STR_TO_DATE(end_date, '%m/%d/%Y');

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
MODIFY COLUMN start_date date, 
MODIFY COLUMN end_date date; 

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
RENAME COLUMN `Number of Discharges` TO count_discharge, 
RENAME COLUMN `Number of Readmissions` TO count_readmissions; 

-- Changing N/A to Nulls in count_discharges -- 

UPDATE fy_2026_hospital_readmissions_reduction_program_hospital
SET count_discharge = NULL
WHERE count_discharge = 'N/A'; 

-- Changing N/A to Nulls in count_readmissions -- 

UPDATE fy_2026_hospital_readmissions_reduction_program_hospital
SET count_readmissions = NULL
WHERE count_readmissions = 'N/A' OR count_readmissions = 'Too Few to Report'; 

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
MODIFY COLUMN count_discharge int, 
MODIFY COLUMN count_readmissions int; 

-- Dropping Footnote Column -- 

ALTER TABLE fy_2026_hospital_readmissions_reduction_program_hospital
DROP COLUMN `Footnote`; 

