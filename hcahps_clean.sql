-- Converting Dates from Text to Date -- 

ALTER TABLE hcahps_hospital
ADD COLUMN new_start_date DATE;

UPDATE hcahps_hospital
SET new_start_date = STR_TO_DATE(start_date, '%m/%d/%Y');

ALTER TABLE hcahps_hospital
DROP COLUMN start_date;

ALTER TABLE hcahps_hospital
ADD COLUMN new_end_date DATE;

UPDATE hcahps_hospital
SET new_end_date = STR_TO_DATE(end_date, '%m/%d/%Y');

ALTER TABLE hcahps_hospital
DROP COLUMN end_date;

-- Renaming Date Columns -- 

ALTER TABLE hcahps_hospital RENAME COLUMN new_start_date TO start_date;
ALTER TABLE hcahps_hospital RENAME COLUMN new_end_date TO end_date;

-- Changing 'Not Applicable', 'Not Available', and empty values to NULL -- 

UPDATE hcahps_hospital
SET hcahps_answer_percent_footnote = NULL
WHERE hcahps_answer_percent_footnote = '';

UPDATE hcahps_hospital
SET patient_survey_star_rating_footnote = NULL
WHERE patient_survey_star_rating_footnote = '';

UPDATE hcahps_hospital
SET number_completed_surveys = 0 
WHERE number_completed_surveys = 'Not Applicable' OR number_completed_surveys = 'Not Available';

UPDATE hcahps_hospital
SET patient_survey_star_rating = NULL 
WHERE patient_survey_star_rating = 'Not Applicable' OR patient_survey_star_rating = 'Not Available';

UPDATE hcahps_hospital
SET hcahps_answer_percent = NULL 
WHERE hcahps_answer_percent = 'Not Applicable' OR hcahps_answer_percent = 'Not Available';

UPDATE hcahps_hospital
SET hcahps_linear_mean_value = NULL 
WHERE hcahps_linear_mean_value = 'Not Applicable' OR hcahps_linear_mean_value = 'Not Available';

UPDATE hcahps_hospital
SET survey_response_rate_percent = NULL 
WHERE survey_response_rate_percent = 'Not Applicable' OR survey_response_rate_percent = 'Not Available';

-- Changing Data Type of Number of Completed Surveys to INT -- 

ALTER TABLE hcahps_hospital 
MODIFY COLUMN number_completed_surveys INT;

SELECT * 
FROM hcahps_hospital
WHERE survey_response_rate_percent_footnote > 0
ORDER BY survey_response_rate_percent_footnote DESC; 

-- Removing Unnecessary Rows -- 

SELECT *
FROM hcahps_hospital
WHERE number_completed_surveys >= 385 
	AND survey_response_rate_percent_footnote NOT BETWEEN 1 AND 28;

DELETE 
FROM hcahps_hospital
WHERE number_completed_surveys < 385;

DELETE 
FROM hcahps_hospital
WHERE survey_response_rate_percent_footnote BETWEEN 1 AND 28;

-- Removing Unnecessary Columns -- 

ALTER TABLE hcahps_hospital
DROP patient_survey_star_rating_footnote, 
DROP hcahps_answer_percent_footnote,
DROP number_completed_surveys_footnote,
DROP survey_response_rate_percent_footnote; 

SELECT *
FROM hcahps_hospital;

-- Checking for Duplicates (NONE FOUND) -- 

WITH ordered_survey AS (
SELECT *,
	ROW_NUMBER() OVER (PARTITION BY facility_id, hcahps_question, hcahps_answer_percent, 
    hcahps_linear_mean_value
    ORDER BY facility_id) AS rownumber 
FROM hcahps_hospital
ORDER BY number_completed_surveys DESC 
) 

SELECT *
FROM ordered_survey
WHERE rownumber > 1; 

SELECT *
FROM hcahps_hospital;

-- Simplifying the Survey Questions -- 

SELECT *,
CASE  
		WHEN hcahps_answer_description = 'Nurses "always" communicated well' THEN 'NCom1'
        WHEN hcahps_answer_description = 'Nurses "usually" communicated well' THEN 'NCom2' 
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" communicated well' THEN 'NCom3'
        WHEN hcahps_answer_description = 'Nurse communication - linear mean score' THEN 'NComLinScore'
        WHEN hcahps_answer_description = 'Nurse communication - star rating' THEN 'NComStar' 
        WHEN hcahps_answer_description = 'Nurses "always" treated them with courtesy and  respect' THEN 'NRespect1' 
        WHEN hcahps_answer_description = 'Nurses "usually"  treated them with courtesy and  respect' THEN 'NRespect2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" treated them with courtesy and  respect' THEN 'NRespect3'
        WHEN hcahps_answer_description = 'Nurses "always" listened carefully' THEN 'NListen1'
        WHEN hcahps_answer_description = 'Nurses "usually" listened carefully' THEN 'NListen2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" listened carefully' THEN 'NListen3'
        WHEN hcahps_answer_description = 'Nurses "always" explained things so they could understand' THEN 'NExplain1'
        WHEN hcahps_answer_description = 'Nurses "always" explained things so they could understand' THEN 'NExplain1'
        WHEN hcahps_answer_description = 'Nurses "usually" explained things so they could understand' THEN 'NExplain2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" explained things so they could understand' THEN 'NExplain3'
        WHEN hcahps_answer_description = 'Doctors "always" communicated well' THEN 'DCom1' 
        WHEN hcahps_answer_description = 'Doctors "usually" communicated well' THEN 'DCom2' 
		WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" communicated well' THEN 'DCom3' 
        WHEN hcahps_answer_description = 'Doctor communication - linear mean score' THEN 'DLinScore' 
        WHEN hcahps_answer_description = 'Doctor communication - star rating' THEN 'DComStar' 
        WHEN hcahps_answer_description = 'Doctors "always" treated them with courtesy and  respect' THEN 'DRespect1'
        WHEN hcahps_answer_description = 'Doctors "usually"  treated them with courtesy and  respect' THEN 'DRespect2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" treated them with courtesy and  respect' THEN 'DRespect3'
        WHEN hcahps_answer_description = 'Doctors "always" listened carefully' THEN 'DListen1' 
        WHEN hcahps_answer_description = 'Doctors "usually" listened carefully' THEN 'DListen2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" listened carefully' THEN 'DListen3' 
        WHEN hcahps_answer_description = 'Doctors "always" explained things so they could understand' THEN 'DExplain1' 
        WHEN hcahps_answer_description = 'Doctors "usually" explained things so they could understand' THEN 'DExplain2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" explained things so they could understand' THEN 'DExplain3'
        WHEN hcahps_answer_description = 'Staff "always" explained' THEN 'SExplain1'
        WHEN hcahps_answer_description = 'Staff "usually" explained' THEN 'SExplain2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained' THEN 'SExplain3'
        WHEN hcahps_answer_description = 'Communication about medicines - linear mean score' THEN 'MedComLinScore' 
        WHEN hcahps_answer_description = 'Communication about medicines - star rating' THEN 'MedComLinScore'
		WHEN hcahps_answer_description = 'Staff "always" explained new medications' THEN 'SExplainMed1'
        WHEN hcahps_answer_description = 'Staff "usually" explained new medications' THEN 'SExplainMed2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained new medications' THEN 'SExplainMed3'
        WHEN hcahps_answer_description = 'Staff "always" explained possible side effects' THEN 'SExplainEffect1'
        WHEN hcahps_answer_description = 'Staff "usually" explained possible side effects' THEN 'SExplainEffect2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained possible side effects' THEN 'SExplainEffect3'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients this information' THEN 'SHomeRecInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients this information' THEN 'SHomeRecInfoY'
        WHEN hcahps_answer_description = 'Discharge information - linear mean score' THEN 'DisInfoLinScore'
        WHEN hcahps_answer_description = 'Discharge information - star rating' THEN 'DisInfoStar'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients information about help after discharge' THEN 'SDisHelpInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients information about help after discharge' THEN 'SDisHelpInfoY'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients information about possible symptoms' THEN 'SSymInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients information about possible symptoms' THEN 'SSymInfoY'
        WHEN hcahps_answer_description = 'Room was "always" clean' THEN 'RoomClean1'
        WHEN hcahps_answer_description = 'Room was "usually" clean' THEN 'RoomClean2'
        WHEN hcahps_answer_description = 'Room was "sometimes" or "never" clean' THEN 'RoomClean3'
        WHEN hcahps_answer_description = 'Cleanliness - linear mean score' THEN 'RoomCleanLinScore'
		WHEN hcahps_answer_description = 'Cleanliness - star rating' THEN 'RoomCleanStar'
		WHEN hcahps_answer_description = '"Always" quiet at night' THEN 'Quiet1'
        WHEN hcahps_answer_description = '"Usually" quiet at night' THEN 'Quiet2'
        WHEN hcahps_answer_description = '"Sometimes" or "never" quiet at night' THEN 'Quiet3'
        WHEN hcahps_answer_description = 'Quietness - linear mean score' THEN 'QuietLinScore'
        WHEN hcahps_answer_description = 'Quietness - star rating' THEN 'QuietStar'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "6" or lower (low)' THEN 'LowRating'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "7" or "8" (medium)' THEN 'MediumRating'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "9" or "10" (high)' THEN 'HighRating'
        WHEN hcahps_answer_description = 'Overall hospital rating - linear mean score' THEN 'HospRatingLinScore'
		WHEN hcahps_answer_description = 'Overall hospital rating - star rating' THEN 'HospRatingStar'
        WHEN hcahps_answer_description = 'Overall hospital rating - star rating' THEN 'HospRatingStar'
        WHEN hcahps_answer_description = '"NO", patients would not recommend the hospital (they probably would not or definitely would not recommend it)' THEN 'NoRecHosp'
        WHEN hcahps_answer_description = '"YES", patients would definitely recommend the hospital' THEN 'YesRecHosp'
        WHEN hcahps_answer_description = '"YES", patients would probably recommend the hospital' THEN 'YesProbRecHosp'
        WHEN hcahps_answer_description = 'Recommend hospital - linear mean score' THEN 'RecHospLinScore' 
        WHEN hcahps_answer_description = 'Recommend hospital - star rating' THEN 'RecHospStar'
        WHEN hcahps_answer_description = 'Summary star rating' THEN 'SummaryStar'
	ELSE hcahps_answer_description
	END AS simplified_question 
FROM hcahps_hospital; 

ALTER TABLE hcahps_hospital
ADD simplified_question VARCHAR(255);

UPDATE hcahps_hospital
SET simplified_question = CASE
		WHEN hcahps_answer_description = 'Nurses "always" communicated well' THEN 'NCom1'
        WHEN hcahps_answer_description = 'Nurses "usually" communicated well' THEN 'NCom2' 
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" communicated well' THEN 'NCom3'
        WHEN hcahps_answer_description = 'Nurse communication - linear mean score' THEN 'NComLinScore'
        WHEN hcahps_answer_description = 'Nurse communication - star rating' THEN 'NComStar' 
        WHEN hcahps_answer_description = 'Nurses "always" treated them with courtesy and  respect' THEN 'NRespect1' 
        WHEN hcahps_answer_description = 'Nurses "usually"  treated them with courtesy and  respect' THEN 'NRespect2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" treated them with courtesy and  respect' THEN 'NRespect3'
        WHEN hcahps_answer_description = 'Nurses "always" listened carefully' THEN 'NListen1'
        WHEN hcahps_answer_description = 'Nurses "usually" listened carefully' THEN 'NListen2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" listened carefully' THEN 'NListen3'
        WHEN hcahps_answer_description = 'Nurses "always" explained things so they could understand' THEN 'NExplain1'
        WHEN hcahps_answer_description = 'Nurses "always" explained things so they could understand' THEN 'NExplain1'
        WHEN hcahps_answer_description = 'Nurses "usually" explained things so they could understand' THEN 'NExplain2'
        WHEN hcahps_answer_description = 'Nurses "sometimes" or "never" explained things so they could understand' THEN 'NExplain3'
        WHEN hcahps_answer_description = 'Doctors "always" communicated well' THEN 'DCom1' 
        WHEN hcahps_answer_description = 'Doctors "usually" communicated well' THEN 'DCom2' 
		WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" communicated well' THEN 'DCom3' 
        WHEN hcahps_answer_description = 'Doctor communication - linear mean score' THEN 'DLinScore' 
        WHEN hcahps_answer_description = 'Doctor communication - star rating' THEN 'DComStar' 
        WHEN hcahps_answer_description = 'Doctors "always" treated them with courtesy and  respect' THEN 'DRespect1'
        WHEN hcahps_answer_description = 'Doctors "usually"  treated them with courtesy and  respect' THEN 'DRespect2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" treated them with courtesy and  respect' THEN 'DRespect3'
        WHEN hcahps_answer_description = 'Doctors "always" listened carefully' THEN 'DListen1' 
        WHEN hcahps_answer_description = 'Doctors "usually" listened carefully' THEN 'DListen2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" listened carefully' THEN 'DListen3' 
        WHEN hcahps_answer_description = 'Doctors "always" explained things so they could understand' THEN 'DExplain1' 
        WHEN hcahps_answer_description = 'Doctors "usually" explained things so they could understand' THEN 'DExplain2'
        WHEN hcahps_answer_description = 'Doctors "sometimes" or "never" explained things so they could understand' THEN 'DExplain3'
        WHEN hcahps_answer_description = 'Staff "always" explained' THEN 'SExplain1'
        WHEN hcahps_answer_description = 'Staff "usually" explained' THEN 'SExplain2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained' THEN 'SExplain3'
        WHEN hcahps_answer_description = 'Communication about medicines - linear mean score' THEN 'MedComLinScore' 
        WHEN hcahps_answer_description = 'Communication about medicines - star rating' THEN 'MedComLinScore'
		WHEN hcahps_answer_description = 'Staff "always" explained new medications' THEN 'SExplainMed1'
        WHEN hcahps_answer_description = 'Staff "usually" explained new medications' THEN 'SExplainMed2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained new medications' THEN 'SExplainMed3'
        WHEN hcahps_answer_description = 'Staff "always" explained possible side effects' THEN 'SExplainEffect1'
        WHEN hcahps_answer_description = 'Staff "usually" explained possible side effects' THEN 'SExplainEffect2'
        WHEN hcahps_answer_description = 'Staff "sometimes" or "never" explained possible side effects' THEN 'SExplainEffect3'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients this information' THEN 'SHomeRecInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients this information' THEN 'SHomeRecInfoY'
        WHEN hcahps_answer_description = 'Discharge information - linear mean score' THEN 'DisInfoLinScore'
        WHEN hcahps_answer_description = 'Discharge information - star rating' THEN 'DisInfoStar'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients information about help after discharge' THEN 'SDisHelpInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients information about help after discharge' THEN 'SDisHelpInfoY'
        WHEN hcahps_answer_description = 'No, staff "did not" give patients information about possible symptoms' THEN 'SSymInfoN'
        WHEN hcahps_answer_description = 'Yes, staff "did" give patients information about possible symptoms' THEN 'SSymInfoY'
        WHEN hcahps_answer_description = 'Room was "always" clean' THEN 'RoomClean1'
        WHEN hcahps_answer_description = 'Room was "usually" clean' THEN 'RoomClean2'
        WHEN hcahps_answer_description = 'Room was "sometimes" or "never" clean' THEN 'RoomClean3'
        WHEN hcahps_answer_description = 'Cleanliness - linear mean score' THEN 'RoomCleanLinScore'
		WHEN hcahps_answer_description = 'Cleanliness - star rating' THEN 'RoomCleanStar'
		WHEN hcahps_answer_description = '"Always" quiet at night' THEN 'Quiet1'
        WHEN hcahps_answer_description = '"Usually" quiet at night' THEN 'Quiet2'
        WHEN hcahps_answer_description = '"Sometimes" or "never" quiet at night' THEN 'Quiet3'
        WHEN hcahps_answer_description = 'Quietness - linear mean score' THEN 'QuietLinScore'
        WHEN hcahps_answer_description = 'Quietness - star rating' THEN 'QuietStar'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "6" or lower (low)' THEN 'LowRating'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "7" or "8" (medium)' THEN 'MediumRating'
        WHEN hcahps_answer_description = 'Patients who gave a rating of "9" or "10" (high)' THEN 'HighRating'
        WHEN hcahps_answer_description = 'Overall hospital rating - linear mean score' THEN 'HospRatingLinScore'
		WHEN hcahps_answer_description = 'Overall hospital rating - star rating' THEN 'HospRatingStar'
        WHEN hcahps_answer_description = 'Overall hospital rating - star rating' THEN 'HospRatingStar'
        WHEN hcahps_answer_description = '"NO", patients would not recommend the hospital (they probably would not or definitely would not recommend it)' THEN 'NoRecHosp'
        WHEN hcahps_answer_description = '"YES", patients would definitely recommend the hospital' THEN 'YesRecHosp'
        WHEN hcahps_answer_description = '"YES", patients would probably recommend the hospital' THEN 'YesProbRecHosp'
        WHEN hcahps_answer_description = 'Recommend hospital - linear mean score' THEN 'RecHospLinScore' 
        WHEN hcahps_answer_description = 'Recommend hospital - star rating' THEN 'RecHospStar'
        WHEN hcahps_answer_description = 'Summary star rating' THEN 'SummaryStar'
	ELSE hcahps_answer_description
    END;

