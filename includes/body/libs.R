############################################################################
############################################################################
##  Document Path: includes/body/libs.R
##
##  Description: Data and additional functions for the body
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
##  Sample regimenDT Breakdown
##
##  ID: Unique identifier for each patient (integer).
##  AGE: Age of the patient (float).
##  WEIGHT: Body weight of the patient (float).
##  GFR: Glomerular filtration rate (float).
##  RENAL_FUNCTION: Categorical variable indicating the renal function status (string).
##  GFR_VALUE: Numerical representation of GFR based on typical physiological values (float).
##  TIME: Time post-dose (float, in hours).
##  DOSE: Administered dose (float, in mg).
##  DV: Plasma concentration of the drug (float, in mg/L; set to . for dosing records).
##  EVID: Evidence of observation (1 for observed, 0 for not observed).
##  DVID: Dummy variable for dependent variable (0 if DV is present).
##  II: Interval since the last dose (float, in hours; typically 0 for first observations).
##  SS: Steady state indicator (0 for not at steady state).
##  TREATMENT: Treatment group assigned to the patient (string; "Drug1", "Drug2", or "Drug3").
##
##  Additional Notes
##  Each patient has a total of 5 records: 2 dosing records (with DV set to .) and 3 observation records (with actual DV values).
##  The distribution of TREATMENT can be randomized as needed for your study design.
#############################################################################
#############################################################################



# initial data
# set.seed(number(1))# For reproducibility

# Define parameters
num_patients <- 100
treatments <- c("Drug1", "Drug2", "Drug3")

# Generate patient demographics
age <- sample(18:90, num_patients, replace = TRUE)
wt <- round(runif(num_patients, 20, 200), 1) # Generate weights as float values

# Assign GFR and renal function based on age and weight
gfr <- numeric(num_patients)
renal_function <- character(num_patients)

for (i in 1:num_patients) {
  if (age[i] < 60) {
    gfr[i] <- round(runif(1, 60, 100), 1)  # Normal
    renal_function[i] <- "Normal"
  } else if (age[i] < 75) {
    gfr[i] <- round(runif(1, 30, 60), 1)   # Mild
    renal_function[i] <- "Mild"
  } else {
    gfr[i] <- round(runif(1, 0, 30), 1)    # Severe
    renal_function[i] <- "Severe"
  }
}

# Generate treatment assignments
treatment <- sample(treatments, num_patients, replace = TRUE)

# Create an empty data frame for the regimenDT
regimenDT <- data.frame()

# Populate the regimenDT with 5 records per patient
for (i in 1:num_patients) {
  # Determine dose based on treatment
  if (treatment[i] == "Drug1") {
    dose_value <- sample(c(50, 100, 200), 1)
  } else if (treatment[i] == "Drug2") {
    dose_value <- sample(c(25, 80, 150), 1)
  } else {
    dose_value <- sample(c(5, 25, 300), 1)
  }

  # Dosing records (2 records with DV set to ".")
  for (j in 0:2) {
    regimenDT <- rbind(regimenDT, data.frame(
      ID = i,
      AGE = age[i],
      WT = wt[i],        # Renamed to WT
      GFR = gfr[i],
      RENAL_FUNCTION = renal_function[i],
      GFR_VALUE = gfr[i],
      TIME = j * 24,     # Assuming dosing every 24 hours
      DOSE = dose_value,  # Use the determined dose value
      DV = ".",
      EVID = 1,
      DVID = 0,
      II = 0,
      SS = 0,
      TREATMENT = treatment[i],
      CMT = 1,           # Compartment for dosing
      AMT = as.character(dose_value)  # Amount given as character
    ))
  }

  # Observation records (3 records with actual DV values)
  for (j in 0:6) {
    dv_value <- round(runif(1, 0.5, 5.5), 1) # Random DV values for observations
    regimenDT <- rbind(regimenDT, data.frame(
      ID = i,
      AGE = age[i],
      WT = wt[i],        # Renamed to WT
      GFR = gfr[i],
      RENAL_FUNCTION = renal_function[i],
      GFR_VALUE = gfr[i],
      TIME = j * 24 + 12,  # Assuming mid-point after dosing
      DOSE = dose_value,
      DV = dv_value,
      EVID = 0,           # Changed to 0 for observations
      DVID = 0,
      II = 0,
      SS = 0,
      TREATMENT = treatment[i],
      CMT = 2,           # Compartment for observations
      AMT = "."          # Set to "." for observations
    ))
  }
}
regimenDT <- regimenDT %>%
  arrange(ID, TIME)

