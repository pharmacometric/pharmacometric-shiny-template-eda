############################################################################
############################################################################
##  Document Path: utils.R
##
##  Description: global functions and variables used by the app
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

library(ggplot2)
library(grid)
library(ggthemes)

source.part = function(path, which = c("ui", "server"), input = NULL, output = NULL, session = NULL) {
  which = match.arg(which)
  for (h in list.files(path = path, pattern = paste0(which, ".R$"), full.names = 1L, recursive = 1L)) {
    this.path = dirname(h)
    source(h, local = TRUE)
  }
}

createSampleData = function(N = 10) {
  ##  ID: Unique identifier for each patient (integer).
  ##  AGE: Age of the patient (float).
  ##  WEIGHT: Body weight of the patient (float).
  ##  GFR: Glomerular filtration rate (float).
  ##  RENAL_FUNCTION: Categorical variable indicating the renal function status (string).
  ##  GFR_VALUE: Numerical representation of GFR based on typical physiological values (float).
  ##  TIME: Time post first dose (float, in hours).
  ##  TSLD: Time post last dose (float, in hours).
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
  num_patients = N
  treatments = c("Drug1", "Drug2", "Drug3")

  # Generate patient demographics
  age = sample(18:90, num_patients, replace = 1L)
  wt = round(runif(num_patients, 20, 200), 1) # Generate weights as float values

  # Assign GFR and renal function based on age and weight
  gfr = numeric(num_patients)
  renal_function = character(num_patients)

  for (i in 1:num_patients) {
    if (age[i] < 60) {
      gfr[i] = round(runif(1, 60, 100), 1) # Normal
      renal_function[i] = "Normal"
    } else if (age[i] < 75) {
      gfr[i] = round(runif(1, 30, 60), 1) # Mild
      renal_function[i] = "Mild"
    } else {
      gfr[i] = round(runif(1, 0, 30), 1) # Severe
      renal_function[i] = "Severe"
    }
  }

  # Generate treatment assignments
  treatment = sample(treatments, num_patients, replace = 1L)

  # Create an empty data frame for the regimenDT
  regimenDT = data.frame()

  # Populate the regimenDT with 5 records per patient
  for (i in 1:num_patients) {
    # Determine dose based on treatment
    if (treatment[i] == "Drug1") {
      dose_value = sample(c(50, 100, 80), 1)
    } else if (treatment[i] == "Drug2") {
      dose_value = sample(c(25, 80, 50), 1)
    } else {
      dose_value = sample(c(10, 25, 50), 1)
    }

    # Dosing records (2 records with DV set to ".")
    for (j in 0:2) {
      regimenDT = rbind(regimenDT, data.frame(
        ID = i,
        AGE = age[i],
        WT = wt[i], # Renamed to WT
        GFR = gfr[i],
        RENAL_FUNCTION = renal_function[i],
        GFR_VALUE = gfr[i],
        TIME = j * 24, # Assuming dosing every 24 hours
        TSLD = 0,
        DOSE = dose_value, # Use the determined dose value
        DV = ".",
        EVID = 1,
        DVID = 0,
        II = 0,
        SS = 0,
        FLAG = 1,
        TRT = treatment[i],
        CMT = 1, # Compartment for dosing
        AMT = as.character(dose_value) # Amount given as character
      ))
    }

    # Observation records (3 records with actual DV values)
    omega = runif(1, 0.001, 0.99)
    conctime = subset(get(paste0("r", dose_value)), TIME %in% c(0, 4, 12, 24, 36, 48, 60, 72, 84, 96))
    # print(dose_value)
    for (j in conctime$TIME) {
      dv_value = conctime[conctime$TIME == j, ]$DV * exp(omega)
      regimenDT = rbind(regimenDT, data.frame(
        ID = i,
        AGE = age[i],
        WT = wt[i], # Renamed to WT
        GFR = gfr[i],
        RENAL_FUNCTION = renal_function[i],
        GFR_VALUE = gfr[i],
        TIME = j, # * 24 + 12,  # Assuming mid-point after dosing
        TSLD = conctime[conctime$TIME == j, ]$TSLD,
        DOSE = dose_value,
        DV = dv_value,
        EVID = 0, # Changed to 0 for observations
        DVID = 0,
        FLAG = 1,
        II = 0,
        SS = 0,
        TRT = treatment[i],
        CMT = 2, # Compartment for observations
        AMT = "." # Set to "." for observations
      ))
    }
  }
  print("generated data...")
  regimenDT %>% arrange(ID, TIME)
}

updateSimStatus = function(message = "No data updates have been made.") {
  shinyjs::runjs(paste0("$('#tracksimulations').html('", message, "')"))
}


updateGraphStatus = function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus').html('", message, "')"))
}

updateGraphStatus2 = function(message = "") {
  shinyjs::runjs(paste0("$('#reportgraphstatus2').html('", message, "')"))
}

updateVariableHolder = function(message = "") {
  shinyjs::runjs(paste0("$('#varnamesholder').html('", message, "')"))
}

disableSims = function(is = "1L") {
  shinyjs::runjs(paste0('$("#runsimbutton").prop("disabled",', is, ")"))
}



styler06 = list(theme(
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler00 = list(theme(
  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  axis.title.y = element_text(face = "bold"),
  panel.background = element_rect(colour = "#333333"),
  strip.text = element_text(face = "bold")
))

styler03 = theme(
  plot.title = element_text(
    face = "bold",
    hjust = 0.5, margin = margin(0, 0, 20, 0)
  ),
  text = element_text(),
  panel.background = element_rect(colour = NA),
  plot.background = element_rect(colour = NA),
  panel.border = element_rect(colour = NA),
  axis.title = element_text(face = "bold", size = rel(1)),
  axis.title.y = element_text(angle = 90, vjust = 2),
  axis.title.x = element_text(vjust = -0.2),
  axis.text = element_text(),
  axis.line.x = element_line(colour = "black"),
  axis.line.y = element_line(colour = "black"),
  axis.ticks = element_line(),
  legend.key = element_rect(colour = NA),
  legend.position = "bottom",
  legend.direction = "horizontal",
  legend.box = "vetical",
  legend.key.size = unit(0.5, "cm"),
  # legend.margin = unit(0, "cm"),
  legend.title = element_text(face = "italic"),
  plot.margin = unit(c(10, 5, 5, 5), "mm"),
  strip.background = element_rect(colour = "#000000", fill = "#f3f3f3", linewidth = rel(1.6)),
  strip.text = element_text(face = "bold")
)
styler01 = list(
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



getTimeV = function(n, t0) {
  if (n > 1) {
    c(0, pop_off(cumsum(t0)))
  } else {
    0
  }
}

pop_off = function(.) {
  .[1:{
    length(.) - 1
  }]
}


calculate_auc = function(time, concentration) {
  # Check if inputs are of the same length
  if (length(time) != length(concentration)) {
    stop("Time and concentration vectors must be of the same length.")
  }

  # Sort the time and concentration data by time
  sorted_indices = order(time)
  time = time[sorted_indices]
  concentration = concentration[sorted_indices]

  # Calculate the AUC using the trapezoidal rule
  auc = sum((time[-1] - time[-length(time)]) * (concentration[-1] + concentration[-length(concentration)]) / 2)

  return(auc)
}



sampleplot = function() {
  colss = sample(grDevices::colors(), 5)
  plot(c(0, 20, 100),
    c(0, 20, 100),
    bg = colss[1:3],
    xlab = "Sample x",
    cex = 2,
    pch = 21,
    axes = 1L,
    ylab = "Sample y",
    bty = "n"
  )
  # box(lwd=2, col=colss[4])
  text(50, 50, "Click 'Generate data version' to get started", cex = 1.5, pos = 3, col = "red")
}




data_summarised_overall = function(dataa) {
  if (nrow(dataa)) {
    dataa %>%
      filter(not.na(.dv)) %>%
      group_by(.colv, .tm) %>%
      reframe(
        dv_mean = mean(.dv),
        dv_med = median(.dv),
        sd = sd(.dv),
        sem = sd(.dv) / sqrt(length((.dv))),
        q95 = quantile(.dv, probs = 0.95),
        q05 = quantile(.dv, probs = 0.05),
        q975 = quantile(.dv, probs = 0.975),
        q025 = quantile(.dv, probs = 0.025)
      )
  }
}

data_summarised_facet = function(dataa) {
  if (nrow(dataa)) {
    dataa %>%
      filter(not.na(.dv)) %>%
      group_by(.ttr, .tm) %>%
      reframe(
        .colv = unique(.colv),
        dv_mean = mean(.dv),
        dv_med = median(.dv),
        sd = sd(.dv),
        sem = sd(.dv) / sqrt(length((.dv))),
        q95 = quantile(.dv, probs = 0.95),
        q05 = quantile(.dv, probs = 0.05),
        q975 = quantile(.dv, probs = 0.975),
        q025 = quantile(.dv, probs = 0.025)
      )
  }
}



extract_pattern = function(file) {
  extract_words_with_braces = function(string) {
    pattern = "\\{([A-Z]+)\\}"
    matches = stringr::str_extract_all(string, pattern)
    if (length(matches) > 0) {
      return(unlist(matches))
    } else {
      return(NULL)
    }
  }

  # Read the file line by line
  lines = readLines(file)
  replacebr = c()
  for (line in lines) {
    replacebr = c(replacebr, extract_words_with_braces(line))
  }
  replacebr
}

# extracted_patterns = suppressMessages(extract_pattern("includes/body/conc.vs.time/code.me.R"))
#
# print(unique(extracted_patterns))
# i = gsub("\\{","\\\\{",extracted_patterns)
# i2 = gsub("\\}","\\\\}",i)
# for(u in unique(i2)){
#   message("'",u,"',1,'','',")
# }
#yy[nzchar(yy)]


#rpl values
# 1 - value available in input to replace
# 2 - To be replaced with "" or remove entirely
# 3 - no values available in input, get in variable

code_download_checks_df = tibble::tribble(
  ~srh, ~rpl, ~with, ~with2,
  "\\{SCRIPTDATA\\}", 1, "datatoUseconc1", "datatoUseconc2",
  "\\{DVVAR\\}", 1, "depvar1", "",
  "\\{TYMEVAR\\}", 1, "indepvar", "indepvar2",
  "\\{LIBRARIES\\}", 3, "", "",
  "\\{CONSOLECLEAR\\}", 1, "", "",
  "\\{DATAFILE\\}", 1, "", "",
  "\\{STORAGEPATH\\}", 1, "", "",
  "\\{FACETVAR\\}", 1, "", "",
  "\\{COLORVAR\\}", 1, "", "",
  "\\{CHOSENDATA\\}", 1, "", "",
  "\\{SUMMARISEPLOT\\}", 1, "", "",
  "\\{LEGENDCOLNUM\\}", 1, "", "",
  "\\{ILABELX\\}", 1, "", "",
  "\\{ILABELY\\}", 1, "", "",
  "\\{LMEANMEDIANALONE\\}", 1, "", "",
  "\\{LREMOVECOLORVAR\\}", 1, "", "",
  "\\{IDVAR\\}", 1, "", "",
  "\\{LSPAGHETTIPLOT\\}", 1, "", "",
  "\\{LSCATTERPLOT\\}", 1, "", "",
  "\\{LSUMMARYPLOT\\}", 1, "", "",
  "\\{LFACETPLOT\\}", 1, "", "",
  "\\{FACETCOLNUM\\}", 1, "", "",
  "\\{LSEMILOGPLOT\\}", 1, "", "",
  "\\{TEXTFONT\\}", 1, "", "",
  "\\{FONTTICKSIZE\\}", 1, "", "",
  "\\{FONTXYSIZE\\}", 1, "", "",
  "\\{FONTSTRIPSIZE\\}", 1, "", "",
  "\\{LEGENDPOS\\}", 1, "", "",
  "\\{IMAGEWIDTH\\}", 1, "", "",
  "\\{IMAGEHEIGHT\\}", 1, "", ""
)
