// ==================================================
// Atomic Utilities
// ==================================================

// Draws a double underline below content with configurable stroke and spacing.
#let double-underline(body, stroke: 0.5pt + black, gap: 2pt) = context {
  let size = measure(body)
  stack(
    spacing: gap,
    body,
    line(length: size.width, stroke: stroke),
    line(length: size.width, stroke: stroke),
  )
}

// Creates an invisible heading anchor for PDF outlines/bookmarks.
#let hidden-heading(..args) = {
  place(hide(heading(numbering: none, ..args)))
}

// ==================================================
// Component
// ==================================================

// Returns a dictionary of styled components (label, value, row, kv-line)
// configured with the provided fonts and dimensions.
#let field-theme(
  font-label: auto,
  font-value: auto,
  size-label: 12pt,
  size-value: 12pt,
  stroke-width: 0.5pt,
  inset: (x: 0pt, bottom: 2pt),
) = {
  // Internal base helper for cell rendering.
  let cell-base(content, font: auto, size: auto, alignment: left, border: none) = {
    rect(
      width: 100%,
      inset: inset,
      stroke: border,
      outset: 0pt,
      align(alignment, text(font: font, size: size, content)),
    )
  }

  // Renders a static field label.
  let label(content, ..args) = {
    let content = text(content, ..args)
    cell-base(content, font: font-label, size: size-label, alignment: left, border: none)
  }

  // Renders an input-style value field with a bottom border.
  let value(content, alignment: center, ..args) = {
    let border = (bottom: stroke-width + black)
    let content = text(content, bottom-edge: "descender", ..args)

    cell-base(content, font: font-value, size: size-value, alignment: alignment, border: border)
  }

  // Generates a grid row tuple containing a label and a value cell.
  let row(key, val, col-label: 1, col-val: 1, key-args: (:), val-args: (:)) = {
    (
      grid.cell(colspan: col-label, label(key, ..key-args)),
      grid.cell(colspan: col-val, value(val, ..val-args)),
    )
  }

  let rows(key, val, min-lines: 2, col-label: 1, col-val: 1, key-args: (:), val-args: (:)) = {
    let vals = if type(val) == str { content.split("\n") } else { val }

    // Pad with empty strings
    if vals.len() < min-lines {
      vals = vals + range(min-lines - vals.len()).map(_ => "　")
    }

    vals
      .enumerate()
      .map(((index, line)) => {
        if index == 0 {
          row(key, line, col-label: col-label, col-val: col-val, key-args: key-args, val-args: val-args)
        } else {
          row(" ", line, col-label: col-label, col-val: col-val, key-args: key-args, val-args: val-args)
        }
      })
      .flatten()
  }

  // Renders an inline `Key: Value` pair (e.g., for non-grid layout).
  // let kv-line(key, val, separator: ": ") = {
  //   par(first-line-indent: 0pt, hanging-indent: 0pt)[
  //     #text(font: font-label, weight: "bold")[#key#separator]
  //     #text(font: font-value)[#val]
  //   ]
  // }

  return (
    label: label,
    value: value,
    row: row,
    rows: rows,
    // kv-line: kv-line
  )
}
