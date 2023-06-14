library("epinet")
HEIGHT <- 480
N <- 50
mycov <- data.frame(id = 1:N, xpos = runif(N), ypos = runif(N))

dyadCov <- BuildX(mycov, binaryCol = list(c(2, 3)),binaryFunc = "euclidean")

eta <- c(0, -10)

net <- SimulateDyadicLinearERGM(N = N, dyadiccovmat = dyadCov, eta = eta)

epi <- SEIR.simulator(M = net, N = N, beta = 1, ki = 3, thetai = 7,ke = 3, latencydist = "gamma")

ragg::agg_png(here::here("static", "images", "infection.png"), height = HEIGHT)
plot(epi,main = "", e.col = "slategrey", i.col = "red", adj = 0, lwd =3)
dev.off()

# ------------------------------------------

xfer_mat = epi |>
as.data.frame() |>
dplyr::select(from = Parent, to = `Node ID`) |>
dplyr::filter(!is.na(from)) |>
as.matrix()


library(igraph)

z <- graph_from_edgelist(xfer_mat, directed = TRUE)
z <- simplify(z)
length(V(z))
V(z)$color <- sample(size =length(V(z)), c("red", "blue"), replace = TRUE)

ragg::agg_png(here::here("static", "images", "network.png"), height = HEIGHT)
plot(z, node.col = "red")
dev.off()

library(magick)

infection_fig <- image_read(here::here("static", "images", "infection.png"))
network_fig <- image_read(here::here("static", "images", "network.png"))
ncflag_fig <- image_read(here::here("static", "images", "nc_flag.jpg"))
image_info(infection_fig)
comb_image <- image_append(c(infection_fig, image_resize(ncflag_fig, glue::glue("480x{HEIGHT}")), network_fig))
480*3
image_resize(comb_image, "2100x250")
image_write(comb_image, here::here("static", "images", "header1.png"))
