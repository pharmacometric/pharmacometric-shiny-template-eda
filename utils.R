setpath <- function(){

}


source.part = function(path, which = c("ui","server"), input = NULL, output = NULL,session = NULL){

  which = match.arg(which)
  for(h in list.files(path = path, pattern = paste0(which,".R$"), full.names = TRUE, recursive = TRUE)){
    this.path = dirname(h)
    source(h, local = TRUE)
  }

}

createSampleData <- function(N = 100){
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
  ##  TRT: Treatment group assigned to the patient (string; "Drug1", "Drug2", or "Drug3").
  ##
  ##  Additional Notes
  ##  Each patient has a total of 5 records: 2 dosing records (with DV set to .) and 3 observation records (with actual DV values).
  ##  The distribution of TRT can be randomized as needed for your study design.
  # initial data
  # set.seed(number(1))# For reproducibility

  # Load conc
  load("includes/body/data/sampleconc.data")

  # Define parameters
  num_patients <- N
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
      dose_value <- sample(c(50, 100, 80), 1)
    } else if (treatment[i] == "Drug2") {
      dose_value <- sample(c(25, 80, 50), 1)
    } else {
      dose_value <- sample(c(10, 25, 50), 1)
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
        TSLD = 0,
        DOSE = dose_value,  # Use the determined dose value
        DV = ".",
        EVID = 1,
        DVID = 0,
        II = 0,
        SS = 0,
        FLAG = 1,
        TRT = treatment[i],
        CMT = 1,           # Compartment for dosing
        AMT = as.character(dose_value)  # Amount given as character
      ))
    }

    # Observation records (3 records with actual DV values)
    omega = runif(1,0.001,0.99)
    conctime = subset(get(paste0("r",dose_value)), TIME %in% c(0, 4, 12, 24, 36, 48, 60, 72, 84, 96))
    #print(dose_value)
    for (j in conctime$TIME) {

      dv_value <- conctime[conctime$TIME==j,]$DV * exp(omega)
      regimenDT <- rbind(regimenDT, data.frame(
        ID = i,
        AGE = age[i],
        WT = wt[i],        # Renamed to WT
        GFR = gfr[i],
        RENAL_FUNCTION = renal_function[i],
        GFR_VALUE = gfr[i],
        TIME = j, # * 24 + 12,  # Assuming mid-point after dosing
        TSLD = conctime[conctime$TIME==j,]$TSLD,
        DOSE = dose_value,
        DV = dv_value,
        EVID = 0,           # Changed to 0 for observations
        DVID = 0,
        FLAG = 1,
        II = 0,
        SS = 0,
        TRT = treatment[i],
        CMT = 2,           # Compartment for observations
        AMT = "."          # Set to "." for observations
      ))
    }
  }
  print("generated data...")
  regimenDT %>% arrange(ID, TIME)
}

updateSimStatus <- function(message = "No data updates have been made."){
  shinyjs::runjs(paste0("$('#tracksimulations').html('",message,"')"))
}


updateGraphStatus <- function(message = ""){
  shinyjs::runjs(paste0("$('#reportgraphstatus').html('",message,"')"))
}

updateGraphStatus2 <- function(message = ""){
  shinyjs::runjs(paste0("$('#reportgraphstatus2').html('",message,"')"))
}

updateVariableHolder <- function(message = ""){
  shinyjs::runjs(paste0("$('#varnamesholder').html('",message,"')"))
}

disableSims <- function(is = "true"){
  shinyjs::runjs(paste0('$("#runsimbutton").prop("disabled",',is,')'))
}


library(ggplot2)
library(grid)
library(ggthemes)
styler06 <- list(theme(
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler00 <- list(theme(
  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler03 <- theme(plot.title = element_text(face = "bold",
            hjust = 0.5, margin = margin(0,0,20,0)),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(),
            axis.line.x = element_line(colour="black"),
            axis.line.y = element_line(colour="black"),
            axis.ticks = element_line(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.box = "vetical",
            legend.key.size= unit(0.5, "cm"),
            #legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="black",fill="#f0f0f0", linewidth =rel(2)),
            strip.text = element_text(face="bold")
    )
styler01 <- list(
  theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14, face = "bold", angle = 90),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 14),
    # panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text.x = element_text(size = 14, face = "bold")
  )
)



getTimeV <- function(n,t0){
  if(n > 1) c(0, pop_off(cumsum(t0)))
  else 0
}

pop_off <- function(.){
  .[1:{length(.)-1}]
}


calculate_auc <- function(time, concentration) {
  # Check if inputs are of the same length
  if (length(time) != length(concentration)) {
    stop("Time and concentration vectors must be of the same length.")
  }

  # Sort the time and concentration data by time
  sorted_indices <- order(time)
  time <- time[sorted_indices]
  concentration <- concentration[sorted_indices]

  # Calculate the AUC using the trapezoidal rule
  auc <- sum((time[-1] - time[-length(time)]) * (concentration[-1] + concentration[-length(concentration)]) / 2)

  return(auc)
}
