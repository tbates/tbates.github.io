library(cowplot)
xmin    = -4
xmax    = 8
Ha_mean = 2.5
H0_mean = 0
Ha_sd   = 1
alpha   = .05/2
alpha_xloc      = qnorm(1-alpha)
values_in_alpha = seq(alpha_xloc, H0_mean+4, length.out = 100)
values_in_beta  = seq(Ha_mean-4, alpha_xloc, length.out = 100)

alphaArea = data.frame(x = values_in_alpha, ymin = 0, ymax = dnorm(values_in_alpha, mean = H0_mean, sd = Ha_sd))
betaArea  = data.frame(x = values_in_beta , ymin = 0, ymax = dnorm(values_in_beta , mean = Ha_mean, sd = Ha_sd))

p1 = ggplot(data = data.frame(x = c(xmin, xmax)), aes(x))
p1 = p1 + scale_x_continuous(breaks = seq(from = -4, to = 8, by = 2))
p1 = p1 + scale_y_continuous(breaks = seq(from = 0, to = .6, by = .1))
p1 = p1 + stat_function(fun = dnorm, n = 501, args = list(mean = 0, sd = 1), colour = "darkgray")
p1 = p1 + stat_function(fun = dnorm, n = 501, args = list(mean = Ha_mean, sd = 1), colour = "red")
# p1 = p1 + geom_vline(xintercept = qnorm(1-alpha), color="blue")
p1 = p1 + geom_ribbon(data = alphaArea, mapping = aes(x = x, ymin = ymin, ymax = ymax), fill="lightgray")
p1 = p1 + geom_ribbon(data = betaArea, mapping = aes(x = x, ymin = ymin, ymax = ymax), fill="red")
p1 = p1 + labs(y = "Frequency", x = "Parameter value", title = "Power") # tag = "A", caption= "citation?"


p1 = p1 + draw_label(substitute(H[0]), x = H0_mean, y = .35, , fontfamily= "Times")
p1 = p1 + draw_label(substitute(H[1]), x = Ha_mean, y = .35, , fontfamily= "Times")
p1 = p1 + draw_label(substitute(beta), x = 1.5, y = .07)
p1 = p1 + draw_label(substitute(alpha), x = 2.25, y = .01)
p1 = p1 + draw_label("Power", x = 3, y = .07, fontfamily= "Times")
p1 = p1 + draw_line(x = c(H0_mean, H0_mean, Ha_mean, Ha_mean), y = c(0.4, 0.41, 0.41, 0.4), color = "blue", size = 1)
p1 + draw_label("NCP", x =(Ha_mean + .6), y = .41)


#' Draw Normal Distribution Density with an area shaded in.
#'
#' @param lb Lower bound of the shaded area. Use \code{-Inf} for a left tail.
#' @param ub Upper bound of the shaded area. Use \code{Inf} for a right tail.
#' @param mean Mean of the normal distribution
#' @param sd Standard deviation of the normal distribution
#' @param limits Lower and upper bounds on the x-axis of the area displayed.
#' @return ggplot object.
#' @examples
#' # Standard normal with upper 2.5% tail shaded
#' normal_prob_area_plot(2, Inf)
#' # Standard normal with lower 2.5% tail shaded
#' normal_prob_area_plot(-Inf, 2)
#' # standard normal with middle 68% shaded.
#' normal_prob_area_plot(-1, 1)
normal_prob_area_plot <- function(lb, ub, mean = 0, sd = 1, limits = c(mean - 4 * sd, mean + 4 * sd)) {
    x <- seq(limits[1], limits[2], length.out = 100)
    xmin <- max(lb, limits[1])
    xmax <- min(ub, limits[2])
    areax <- seq(xmin, xmax, length.out = 100)
    area <- data.frame(x = areax, ymin = 0, ymax = dnorm(areax, mean = mean, sd = sd))
    (ggplot()
     + geom_line(data.frame(x = x, y = dnorm(x, mean = mean, sd = sd)), mapping = aes(x = x, y = y))
     + geom_ribbon(data = area, mapping = aes(x = x, ymin = ymin, ymax = ymax), fill="lightgray")
     + scale_x_continuous(limits = limits))
}