
<!-- README.md is generated from README.Rmd. Please edit that file -->

# encodeR

<!-- badges: start -->

[![R build
status](https://github.com/UBC-MDS/encodeR/workflows/R-CMD-check/badge.svg)](https://github.com/UBC-MDS/encodeR/actions)
[![codecov](https://codecov.io/gh/UBC-MDS/encodeR/branch/master/graph/badge.svg)](https://codecov.io/gh/UBC-MDS/encodeR)
<!-- badges: end -->

This package seeks to provide a convenient set of functions that allow
for the encoding of categorical features in potentially more informative
ways when compared to other, more standard methods. The user will feed
as input a training and testing dataset with categorical features, and
the resulting data frames returned will be preprocessed with a specific
encoding of the categorical features. At a high level, this package
automates the preprocessing of categorical features in ways that exploit
particular correlations between the different categories and the data
**without** increasing the dimension of the dataset, like in one hot
encoding. Thus, through the more deliberate handling of these
categorical features, higher model performance can possibly be achieved.

Please read [this
vignette](https://ubc-mds.github.io/encodeR/articles/encodeR-vignette.html)
for a hands on guide on how to use encodeR.

## Features

This package contains four functions, each that accept two tibbles
representing the train and test sets. Depending on the method, the
functions will also require additional arguments depending on how the
encodings are calculated for each category. For now, the package aims to
support binary classification and regression problems.

1.  `onehot_encoder()`: the standard one-hot encoding of categorical
    features, which will create K-1 columns of 0/1 indicator variables.
2.  `frequency_encoder()`: calculates encodings based off the observed
    frequency of each category in the training set.
3.  `target_encoder()`: calculates encodings by computing the average
    observed response per each category.
4.  `conjugate_encoder()`: calculates encodings based off Bayes rule
    using conjugate priors and the mean of the posterior distribution.
    The original paper for this method can be found
    [here.](https://arxiv.org/pdf/1904.13001.pdf)

## Where encodeR Fits in The R Ecosystem

There are some packages in R that include different, more sophisticated
kinds of encoding methods. The well known framework
[H20](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-munging/target-encoding.html)
has a function for target encoding, and the
[recipes](https://cran.r-project.org/web/packages/recipes/recipes.pdf)
package has the ability to one hot encode. The package
[cattonum](https://cran.r-project.org/web/packages/cattonum/cattonum.pdf)
also contains many kinds of encoding schemes such as frequency encoding,
target encoding, and one hot encoding. Based on research, there does not
exist a package in R that implements conjugate encoding.

The problem with the R ecosystem for categorical encoding is that there
is not one package that contains all of the most popular encoders. This
results in users having to import many different packages to experiment
with different encoders, each with their own syntax and interface. This
package hopes to give users one, coherent framework for encoding
categorical features in R. Furthermore, methods that have not been
packaged in R like conjugate encoding will directly add something new to
the R
ecosystem.

## Installation

<!-- You can install the released version of encodeR from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("encodeR") -->

<!-- ``` -->

Currently, this package is not yet on CRAN. However, you can install the
latest development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UBC-MDS/encodeR")
```

## Dependencies

  - R (\>= 3.4)
  - dplyr
  - readr
  - rlang
  - tidyr
  - purrr
  - fastDummies
  - magrittr

## Examples

This package can allow one to fit many different kinds of encodings for
categorical features easily. For example, one can fit a conjugate
encoding of some categorical variables by:

``` r
library(encodeR)
library(tidyverse)
#> ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.0     ✓ purrr   0.3.3
#> ✓ tibble  2.1.3     ✓ dplyr   0.8.5
#> ✓ tidyr   1.0.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.4.0
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

my_data <- tibble(
  fruit = c("Apple", "Orange", "Apple", "Apple", "Banana"),
  color = c("Red", "Blue", "Orange", "Red", "Red"),
  target = c(1, 0, 1, 1, 1)
)

conjugate_encoder(
  my_data,
  y = my_data$target,
  cat_columns = c("fruit", "color"),
  prior_params = list(alpha = 3, beta = 10), 
  objective = "binary"
  )
#> Joining, by = "fruit"
#> Joining, by = "color"
#> [[1]]
#> # A tibble: 5 x 3
#>   target fruit_encoded color_encoded
#>    <dbl>         <dbl>         <dbl>
#> 1      1         0.333         0.333
#> 2      0         0.167         0.167
#> 3      1         0.333         0.222
#> 4      1         0.333         0.333
#> 5      1         0.222         0.333
```

This package can also fit regression data sets, and automatically join
the learned encodings on a held out test set if the user wants to:

``` r

my_data_reg <- tibble(
  fruit = c("Apple", "Orange", "Apple", "Apple", "Banana", "Orange", "Apple"),
  color = c("Red", "Blue", "Orange", "Red", "Red", "Blue", "Green"),
  target = c(3.5, 10, 10.912, 3.14159, 10, 15, 1000)
)

train <- my_data_reg[1:5, ]
test <- my_data_reg[6:7, ]

encodings <- target_encoder(
  train,
  test,
  y = train$target,
  cat_columns = c("fruit", "color"),
  prior = 0.8, 
  objective = "regression" 
)

encodings$train
#> # A tibble: 5 x 3
#>   fruit color target
#>   <dbl> <dbl>  <dbl>
#> 1  6.20  5.96   3.5 
#> 2  8.89  8.89  10   
#> 3  6.20  9.40  10.9 
#> 4  6.20  5.96   3.14
#> 5  8.89  5.96  10
encodings$test
#> # A tibble: 2 x 3
#>   fruit color target
#>   <dbl> <dbl>  <dbl>
#> 1  8.89  8.89     15
#> 2  6.20  7.51   1000
```

<!-- What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so: -->

<!-- ```{r cars} -->

<!-- summary(cars) -->

<!-- ``` -->

<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. -->

<!-- You can also embed plots, for example: -->

<!-- ```{r pressure, echo = FALSE} -->

<!-- plot(pressure) -->

<!-- ``` -->

<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub! -->
