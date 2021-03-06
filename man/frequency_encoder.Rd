% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/frequency_encoder.R
\name{frequency_encoder}
\alias{frequency_encoder}
\title{frequency_encoder}
\usage{
frequency_encoder(X_train, X_test = NULL, cat_columns)
}
\arguments{
\item{X_train}{A `tibble` or `data.frame` representing the training data set
containing some categorical features/columns.}

\item{X_test}{A `tibble` or `data.frame` representing the test set,
containing some set of categorical features/columns.}

\item{cat_columns}{A character vector containing the names of the
categorical columns in the tibble that should be encoded.}
}
\value{
A `list` with processed training and test sets (if provided), in
which the named categorical columns are replaced with their encodings.
}
\description{
This function encodes categorical variables using the frequencies of each
category.
}
\examples{
frequency_encoder(
X_train = mtcars,
cat_columns = c("gear", "carb"))
}
