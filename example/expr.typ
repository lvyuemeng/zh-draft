#import "../lib.typ": *

#let normal-size = 20pt
#let label-size = (normal-size * 10)

#let theme = components.field-theme(
  font-label: "KaiTi",
  size-label: normal-size,
  size-value: normal-size,
)

#let expr = {
  grid(
    columns: (label-size, 1fr),
    // column-gutter: normal-size,
    ..(theme.row)("姓名", "XX", key-args: (stroke: 1pt), val-args: (stroke: 1pt)),
    ..(theme.row)("性别", "XX", key-args: (stroke: 1pt), val-args: (stroke: 1pt)),
  )
}

#expr
