get_codon_table <- function(n=1) {
  require(tidyverse)
  cod <- system2("gp_seq2prot", sprintf("-c %d -P l", n), stdout=TRUE) %>% paste(collapse="\n")
  cod <- read.table(text=cod, col.names=c("codon", "L1", "L3" ))
  return(cod)
}

get_codon_pivot <- function(cod) {
  require(tidyverse)
  cod %>%
	mutate(AA=sprintf("%s %s (%s)", codon, L1, L3)) %>% 
	mutate(L2 = gsub("^.(.).$", "\\1" , codon), L13 = gsub("^(.).(.)$", "\\1\\2", codon)) %>% 
	pivot_wider(id_cols=L13, values_from=AA, names_from=L2) %>% 
	mutate("First position"=gsub("(.).", "\\1", L13)) %>%
	select(all_of("First position"), T:G) %>%
	mutate("First position"=ifelse(duplicated(.data[["First position"]]), ",,", .data[["First position"]]))

}

kable_print_codon_table <- function(cdn, compare=NULL, font_size=11) {
  cdn2 <- compare
  ret <- kable(cdn) %>% kable_styling(font_size=font_size, full_width=TRUE) 
  if(!is.null(cdn2)) {
    ret <- ret %>%
      column_spec(2, color=ifelse(cdn2[,2] == cdn[,2], ifelse(grepl("STP", cdn2[[2]]), "#BB0000", "#000000"), "#FFFFFF"), background=ifelse(cdn2[,2] == cdn[,2], "#FFFFFF", "#CC0000")) %>%
      column_spec(3, color=ifelse(cdn2[,3] == cdn[,3], ifelse(grepl("STP", cdn2[[3]]), "#BB0000", "#000000"), "#FFFFFF"), background=ifelse(cdn2[,3] == cdn[,3], "#FFFFFF", "#CC0000")) %>%
      column_spec(4, color=ifelse(cdn2[,4] == cdn[,4], ifelse(grepl("STP", cdn2[[4]]), "#BB0000", "#000000"), "#FFFFFF"), background=ifelse(cdn2[,4] == cdn[,4], "#FFFFFF", "#CC0000")) %>%
      column_spec(5, color=ifelse(cdn2[,5] == cdn[,5], ifelse(grepl("STP", cdn2[[5]]), "#BB0000", "#000000"), "#FFFFFF"), background=ifelse(cdn2[,5] == cdn[,5], "#FFFFFF", "#CC0000"))
  } else {
    ret <- ret %>%
      column_spec(2, color=ifelse(grepl("STP", cdn[[2]]), "#BB0000", "#000000")) %>%
      column_spec(3, color=ifelse(grepl("STP", cdn[[3]]), "#BB0000", "#000000")) %>%
      column_spec(4, color=ifelse(grepl("STP", cdn[[4]]), "#BB0000", "#000000")) %>%
      column_spec(5, color=ifelse(grepl("STP", cdn[[5]]), "#BB0000", "#000000"))
  }
  ret <- ret %>%	add_header_above(header=c("", "Second position in a codon"=4))
  return(ret)
}


#' Plot an alignment / Needleman-Wunsch algorithm
#'
#' @param a1 first sequence
#' @param a2 second sequence
#' @param n How many steps of the alignment
#' @param plot_mtx TRUE/FALSE – whether to plot the scoring matrix
#' @param show_arrows_vert (integer) how many arrows in the first column to plot
#' @param show_arrows_horiz (integer) how many arrows in the first row to plot
#' @param show_arrows_diag (integer) how many diagonal arrows to plot
#' @param show_arrows_horiz_all (logical) whether to show all horizontal arrows
#' @param show_arrows_vert_all (logical) whether to show all vertical arrows
#' @param show_scores (NULL or vector of two integers) whether to show (and
#'        how much) of the "black" arrows and alignment scores
#' @param show_traceback (integer) whether to show traceback and if yes, how much (use 1 to show the last step only)
#' @param sel_traceback (integer vector) if there is more than one possible alignment, choose which one(s) to show
#' @param rev_black_arrows reverse the direction of the "black" arrows
#' @param nomargin do not show the margin with the alignment in text form
#' @param highlight list of pairs of integers – which cells to highlight
plot_nw <- function(a1, a2, n=NULL, plot_mtx=FALSE, show_arrows_horiz=0, show_arrows_vert=0,
  show_arrows_diag=0,
  show_arrows_horiz_all=FALSE, show_arrows_vert_all=FALSE,
  rev_black_arrows=FALSE,
  show_scores=NULL, show_traceback=NULL, sel_traceback=NULL,
  nomargin=FALSE,
  highlight=NULL) {

  if(nchar(a1) != nchar(a2)) stop("length of a1 must be equal to length of a2")
  if(is.null(n)) n <- nchar(a1)
  a1_a <- unlist(strsplit(a1, ""))
  a2_a <- unlist(strsplit(a2, ""))
  a1_s <- a1_a[ a1_a != "-" ]
  a2_s <- a2_a[ a2_a != "-" ]
  n1 <- length(a1_s)
  n2 <- length(a2_s)


  if(nomargin) {
    xlim <- c(-1.5, n1)
  } else {
    xlim <- c(-1.5, n1 + 1.5 + n1 + n2)
  }
  plot(NULL, xlim=xlim, ylim=c(n2+.5, -1.5), bty="n", xaxt="n", yaxt="n", xlab="Sequence 1", ylab="Sequence 2")

  chw <- strwidth("X")
  chh <- strheight("X")
  abline(h=(-2:n2)+.5, col="grey")
  abline(v=(-2:n1)+.5, col="grey")
  text(y=-1, x=1:n1, a1_s)
  text(x=-1, y=1:n2, a2_s)

  mtx <- get_mtx(a1_s, a2_s)
  if(plot_mtx) { plot_mtx(mtx, n1, n2) }

  if(n > 0) {
    show_path(a1_a, a2_a, n, n1)
  }

  if(show_arrows_horiz > 0) { show_arrows_horiz(min(show_arrows_horiz, n1), c=0) }
  if(show_arrows_vert > 0) { show_arrows_vert(min(show_arrows_vert, n2), r=0) }

  if(show_arrows_diag > 0) { show_arrows_diag(show_arrows_diag, mtx, n1, n2) }
  if(show_arrows_horiz_all) { 
    for(i in 0:n2) { show_arrows_horiz(n1, c=i) }
  }
  if(show_arrows_vert_all) { 
    for(i in 0:n1) { show_arrows_vert(n2, r=i) }
  }

  nw <- nwcalc(mtx)
  paths <- get_paths(nw)
  if(!is.null(show_traceback)) {
    show_traceback(mtx, paths, show_traceback, sel_traceback)
  }
  if(!is.null(show_scores)) {
    if(length(show_scores) != 2) stop("show_scores must be a vector of length 2")
    show_scores(show_scores, mtx, nw, n1, n2, rev_black_arrows)
  }

  if(!is.null(highlight)) {
    for(i in highlight) {
      if(i[1] > n1) i[1] <- n1
      if(i[2] > n2) i[2] <- n2
      rect(i[1] - .5, i[2] - .5, i[1] + .5, i[2] + .5, col=NA, border="red", lwd=3)
    }
  }

}

show_traceback <- function(mtx, paths, show_traceback, sel_traceback) {
  require(RColorBrewer)
  n1 <- ncol(mtx)
  n2 <- nrow(mtx)
  n <- show_traceback - 1

  a1_s <- colnames(mtx)
  a2_s <- rownames(mtx)

  if(is.null(sel_traceback)) sel_traceback <- 1

  pal <- brewer.pal(max(c(3, sel_traceback)), "Set1")

  for(path.i in sel_traceback) {
    p <- paths[[path.i]]

    x0 <- n1
    y0 <- n2
    pl <- length(p)
    nn <- min(n, length(p) - 2)
    print(p)

    for(i in pl:(pl - nn)) {
      ch <- p[i]
      if(ch == "l") {
        x1 <- x0 - 1
        y1 <- y0
      } else if(ch == "t") {
        x1 <- x0
        y1 <- y0 - 1
      } else {
        x1 <- x0 - 1
        y1 <- y0 - 1
      }

      segments(x1, y1, x0, y0, lwd=5, col=pal[path.i])
      points(x0, y0, col=pal[path.i], pch=19, cex=2)

      chs1 <- ifelse(ch == "t", "–", a1_s[x0])
      chs2 <- ifelse(ch == "l", "–", a2_s[y0])

      
      text(n1 + i, path.i * 2 - 2, chs1, col=pal[path.i])
      text(n1 + i, path.i * 2 - 1, chs2, col=pal[path.i])
      if(chs1 == chs2) {
        text(n1 + i, path.i * 2 - 1.5, '|', col=pal[path.i])
      }

      x0 <- x1
      y0 <- y1

    }

  }

  

}


show_scores <- function(n, mtx, nw, n1, n2, rev_black_arrows=FALSE) {

  nh <- min(n[1], n1) + 1
  nv <- min(n[2], n2) + 1
  dir <- nw$dir[1:(nv), 1:(nh), drop=F] # direction matrix
  out <- nw$out[1:(nv), 1:(nh), drop=F] # score matrix

  x0 <- col(out) - 1
  y0 <- row(out) - 1
  scores <-  out
  text(x0, y0, scores, cex=1.2)

  left  <- which(bitwAnd(dir, 1) > 0)
  right <- which(bitwAnd(dir, 2) > 0)
  diag  <- which(bitwAnd(dir, 4) > 0)

  if(rev_black_arrows) {
    arrows(x0[left] - .3, y0[left],       x0[left] - .7, y0[left],       length=.1, lwd=2)
    arrows(x0[right],     y0[right] - .3, x0[right],     y0[right] - .7, length=.1, lwd=2)
    arrows(x0[diag] - .3, y0[diag] - .3,  x0[diag] - .7, y0[diag] - .7,  length=.1, lwd=2)
  } else {
    arrows(x0[left] - .7, y0[left], x0[left] - .3, y0[left], length=.1, lwd=2)
    arrows(x0[right], y0[right] - .7, x0[right], y0[right] - .3, length=.1, lwd=2)
    arrows(x0[diag] - .7, y0[diag] - .7, x0[diag] - .3, y0[diag] - .3, length=.1, lwd=2)
  }

}


get_paths <- function(res) {
  dir <- res$dir
  out <- res$out
  n1  <- ncol(out)
  n2  <- nrow(out)
  if(n1 == 1 & n2 == 1) { return(list('*')) }

  dirs <- list()
  if(bitwAnd(dir[n2, n1], 1)) dirs <- c(dirs, list(l=c(n1 - 1, n2)))
  if(bitwAnd(dir[n2, n1], 2)) dirs <- c(dirs, list(t=c(n1, n2 - 1)))
  if(bitwAnd(dir[n2, n1], 4)) dirs <- c(dirs, list(d=c(n1 - 1, n2 - 1)))

  paths <- imap(dirs, ~ {
    .dir <- .y
    .ret <- get_paths(list(dir=dir[1:.x[2], 1:.x[1], drop=FALSE], out=out[1:.x[2], 1:.x[1], drop=FALSE]))
    .ret <- map(.ret, ~ c(unlist(.x), .dir))
    .ret
  })

  paths <- unlist(paths, recursive=FALSE)

  return(paths)
}

nwcalc <- function(mtx, gp=-1) {

  n1 <- ncol(mtx)
  n2 <- nrow(mtx)

  mtx_out <- matrix(0, nrow=n2 + 1, ncol=n1 + 1)
  mtx_dir <- matrix(0, nrow=n2 + 1, ncol=n1 + 1)

  mtx_dir[1, 2:(n1+1)] <- 1
  mtx_dir[2:(n2+1), 1] <- 2
  colnames(mtx_dir) <- c(" ", colnames(mtx))
  rownames(mtx_dir) <- c(" ", rownames(mtx))

  mtx_out[1, 2:(n1+1)] <- (1:n1) * gp
  mtx_out[2:(n2+1), 1] <- (1:n2) * gp
  colnames(mtx_out) <- c(" ", colnames(mtx))
  rownames(mtx_out) <- c(" ", rownames(mtx))


  for(rr in 1:n2) {
    for(cc in 1:n1) {
      l <- mtx_out[rr + 1, cc] + gp
      u <- mtx_out[rr, cc + 1] + gp
      d <- mtx_out[rr, cc] + mtx[rr, cc]
      m <- max(c(l, u, d))
      mtx_dir[rr + 1, cc + 1] <- c(0, c(1, 2, 4)[ c(l, u, d) == m ]) %>% reduce(bitwOr)
      mtx_out[rr + 1, cc + 1] <- m
    }
  }

  return(list(dir=mtx_dir, out=mtx_out))
}


show_arrows_diag <- function(n, mtx, n1, n2) {

  n <- n - 1
  nh <- min(n, n1 - 1)
  nv <- min(n, n2 - 1)

  scores <- as.integer(t(mtx[ 1:(nv + 1), 1:(nh + 1) ]))

  x0 <- rep((0:nh) + .3, (nv + 1))
  x1 <- x0 + .3
  y0 <- rep((0:nv) + .3, each=(nh + 1))
  y1 <- y0 + .3
  arrows(x0, y0, x1, y1, length=.05, col="red")
  text(x0 + .15, y0 + .15, scores, col="red", cex=.8, adj=c(0,0))

}

show_arrows_horiz <- function(n, c) {
  show_arrows_horiz <- n - 1
  x0 <- (0:show_arrows_horiz) + .3
  x1 <- (0:show_arrows_horiz) + .6
  arrows(x0, c, x1, c, col="red", length=.05)
  text((0:show_arrows_horiz)+.5, c-.1, "-1", col="red", cex=.8, adj=c(.5, 0))
}

show_arrows_vert <- function(n, r) {
    show_arrows_vert <- n - 1
    y0 <- (0:show_arrows_vert) + .3
    y1 <- (0:show_arrows_vert) + .6
    arrows(r, y0, r, y1, col="red", length=.05)
    text(r-.1, (0:show_arrows_vert)+.5, "-1", col="red", cex=.8, adj=c(.5, 0))
}

get_mtx <- function(a1_s, a2_s) {
  mtx <- map(a2_s, ~ as.integer(.x == a1_s)) %>% reduce(rbind)
  colnames(mtx) <- a1_s
  rownames(mtx) <- a2_s
  return(mtx)
}

plot_mtx <- function(mtx, n1, n2) {

  text(0, 1:n2, "0", adj=c(0,1), col="blue")
  text(0:n1, 0, "0", adj=c(0,1), col="blue")

  text(col(mtx), row(mtx), mtx, adj=c(0,1), col="blue")
}

show_path <- function(a1_a, a2_a, n, n1) {
  x0 <- 0
  y0 <- 0
  for(i in 1:n) {
    ch1 <- a1_a[i]
    ch2 <- a2_a[i]

    if(ch1 == "-") {
      x1 <- x0
      y1 <- y0 + 1
    } else if(ch2 == "-") {
      x1 <- x0 + 1
      y1 <- y0 
    } else {
      x1 <- x0 + 1
      y1 <- y0 + 1
    }


    segments(x0, y0, x1, y1, lwd=3, col="darkgrey")
    points(x1, y1, pch=19, cex=2)

    match <- ifelse(ch1 == ch2, "|", " ")
    text(n1 + i, 1:3, c(ch1, match, ch2))


    x0 <- x1
    y0 <- y1
  }

}
