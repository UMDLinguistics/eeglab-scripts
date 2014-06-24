plot_28 <- function(expDir, expName, subjListFileID, condList, condLabelList, epBeg, epEnd, sampleRate){

  #Written by Diogo Almeida, NYU Abu Dhabi
  #Modified by Ellen Lau
  ##Example: plot_28('MOOSE','Moose','MOOSE_n36',c(1,2),c('runny nose', 'dainty nose'),-100,798,500)

  
  ######Set up electrode properties for standard UMD layout (FP1 only)######
  
  ##This gives the names of the 28 electrodes to plot in the order that they should be plotted
  umd.electrodes.1 <- c(
  "F7", "F3", "Fz", "F4", "F8", 
  "FT7", "FC3", "FCz", "FC4", "FT8", 
  "T7", "C3", "Cz", "C4", "T8", 
  "TP7", "CP3", "CPz", "CP4", "TP8", 
  "P7", "P3", "Pz", "P4", "P8", 
  "O1", "Oz", "O2"  )

  # Layout: A 6 rows by 5 columns matrix makes 30 slots for electrodes.
  # We actually only use 28 in this script, excluding RM and FP1
  
  umd.layout.1 <- c(
   1,  2,  3,  4,  5, 
   6,  7,  8,  9, 10, 
  11, 12, 13, 14, 15, 
  16, 17, 18, 19, 20, 
  21, 22, 23, 24, 25, 
  29, 26, 27, 28, 30 
  )

  numElec <- 28

  # the data
  timepoints <- seq(epBeg,epEnd,1000/sampleRate)
  cond1 <- condList[1]
  cond2 <- condList[2]
  baseline <- 100

  # --------------------------------
  # Configuration of plot parameters
  # --------------------------------
  # electrodes and order in which they will be plotted
  elecnames <- umd.electrodes.1
  orderplot <- umd.layout.1

  # graphic parameters
  yarrow <- 2
  ltype <- c(1, 1)
  lwd.data <- 2
  lwd.segments <- 1
  lwd.yarrow <- 1
  cex.elecname <- 1
  line.colors <- c("black", "red")
  yarrows <- c(-yarrow, yarrow)
  ylimit  <- c(-5, 5)
  tick.length <- 0.3

  # Guarantees that the plot will have always enough range to plot +-yarrow
  ylow   <- ifelse(ylimit[1] > -yarrow, -yarrow, ylimit[1])
  yhigh  <- ifelse(ylimit[2] < yarrow, yarrow, ylimit[2])
  ylimit <- c(yhigh,ylow)

  plotFile <- paste('/Users/Shared/Experiments/',expDir,'/results/R/figures/ERP28_c',cond1,'_c',cond2,'.png',sep="")
  png(file=plotFile,width=170, height=140, units="mm",pointsize=12,res=300)

  # Check layout to see if it is ok
  plot.layout = layout(matrix(orderplot, ncol = 5, nrow = 6, byrow = T), T)
  layout.show(plot.layout)

  
  # --------------------------------
  # Plots the data
  # --------------------------------
  
  for (i in 1:numElec) {
    # Get rid of unwanted margin space
    par(mar = c(0, 0.5, 0, 0.5))
    
    # Get grand-average data for current electrode 
    currElec <- umd.electrodes.1[i]
    erpData1 <- grandAvgElec(expDir, expName, subjListFileID,cond1,currElec)
    erpData2 <- grandAvgElec(expDir, expName, subjListFileID,cond2,currElec)
    
    ####################
    ## Plot the ERP data
    # Condition 1
    plot(timepoints, erpData1, type = "l", col = line.colors[1], bty = "n", 
      ylim = ylimit, axes = F, lwd = lwd.data, lty = ltype[1]
    )
    # Condition 2
    lines(timepoints, erpData2, col = line.colors[2], lty = ltype[2], lwd = lwd.data)

    ####################################
    ##Add rest of critical plot features
    
    # 0-amplitude line
    abline(h = 0, col = "black")

    # stimulus presentation line
    arrows(x0 = 0, y0 = yarrows[1], x1 = 0, y1 = yarrows[2], length = 0.05, angle = 90,
      code = 3, lwd = lwd.yarrow   
    )
   
    # ticks of time increments
    segments(x0 = seq(100, 1000, by = 100), y0 = -tick.length, 
      x1 = seq(100, 1000, by = 100), y1 = tick.length, lwd = lwd.segments
    )
   
    # electrode label
    text(x = baseline/(1000/sampleRate), y = ylow + 0.5, elecnames[i], cex = cex.elecname)
  }

  
  
  # --------------------------------------------------------
  # plot erp legend in square number 29 (lower left corner) 
  # --------------------------------------------------------
  # Get rid of unwanted margin space
  par(mar = c(0, 0.5, 0, 0.5))

  # create the skeleton of an electrode plot (notice the type = "n" option).  
  plot(timepoints, erpData1, type = "n", col = line.colors[1], bty = "n", 
  ylim = ylimit, axes = F, lwd = lwd.data, lty = ltype[1]
  )

  # plot the legend
  abline(h = 0, col = "black")
  arrows(x0 = 0, y0 = yarrows[1], x1 = 0, y1 = yarrows[2], length = 0.05, angle = 90,
    code = 3, lwd = lwd.yarrow   
)
  segments(x0 = seq(100, 1000, by = 100), y0 = -tick.length, x1 = seq(100, 1000, by = 100), 
    y1 = tick.length, lwd = lwd.segments
  )
  text(x = baseline * 1.8, y = -yarrow-.5, 
    substitute(paste(a, mu, "V"), list(a = trunc(-yarrow))), cex = cex.elecname
  )
  text(x = c(seq(100, 700, by = 300), 900), y = yhigh - (yhigh / 2),
    labels = c(seq(100, 700, by = 300), "ms"), cex = cex.elecname
  )
  #text(x = 500, y = yhigh - (yhigh / 4), labels = "ms", cex = cex.elecname)
 
  # ----------------------------------------------------
  # plot legend in square number 30 (lower right corner)
  # ----------------------------------------------------
  # Get rid of unwanted margin space
  par(mar = c(0, 0.5, 0, 0.5))

  # create the skeleton of an electrode plot (notice the type = "n" option).
  plot(timepoints, erpData1, type = "n", col = line.colors[1], bty = "n", 
    ylim = ylimit, axes = F, lwd = lwd.data, lty = ltype[1]
  )
  segments(x0 = c(100, 100), y0 = c(0, 2), x1 = c(300, 300), y1 = c(0, 2), lwd = lwd.data, 
    lty = ltype,col=c(line.colors[2],line.colors[1])
  )
  text(x = c(350, 350), y = c(0, 2), labels = c(condLabelList[2], condLabelList[1]), pos = 4, 
    cex = cex.elecname
  )
  
  
  ##Close figure, save to file
  dev.off()
  
}
