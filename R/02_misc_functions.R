#' Misc functions
#' functions that are helpers and can be useful in several contexts


#' create an id out of the key and the redcap record_id
#'
#' @param key single number/string or vector
#' @param record_id single number or vector
#'
#' @return single value or vector of the id's (record_id appended to key)
#' @export
#'
#' @examples
create_id <- function(key, record_id) {
  result <- paste0(key, record_id)
  return(as.integer(result))
}

#' reverse_item
#' vectorized function to reverse on item or a vector of items
#' useful for questionnaires where some items have a reversed scale
#'
#' @param v the value that should be reversed
#' @param max_value the maximum value of the scale
#'
#' @return
#' @export
#'
#' @examples
reverse_item <- function(v, max_value) {
  return(max_value - v)
}



