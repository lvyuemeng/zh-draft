// Date Formatter
#let format-date(date) = {
  if type(date) == datetime {
    date.display("[year]年[month]月[day]日")
  } else {
    date
  }
}

// Anonymizer
// returns "█████" if anonymous is true, otherwise returns value
#let mask-field(value, anonymous, length:5) = {
  if anonymous {
    "█" * length
  } else {
    value
  }
}

// List Joiner
// Helper to join title lines back into a single string for the abstract header
#let join-by-sep(content, separator: " ") = {
  if type(content) == array {
    content.join(separator)
  } else {
    content
  }
}