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
  font-label: none,
  font-value: none,
  size-label: 12pt,
  size-value: 12pt,
  inset: (x: 0pt, bottom: 2pt),
) = {
  // Internal base helper for cell rendering.
  let cell-base(content, font: none, size: auto, alignment: center, stroke: none) = {
    // a default cjk character to match the height between cjk and non-cjk character.
    let strut = box(width: 0pt, hide(text(font: "KaiTi", size: size)[""]))
    rect(
      width: 100%,
      inset: inset,
      stroke: stroke,
      outset: 0pt,
      align(alignment, if font == none { text(size: size, content) + strut } else {
        text(font: font, size: size, content) + strut
      }),
    )
  }

  // Renders a static field label.
  let label(content, alignment: center, stroke: none) = {
    cell-base(content, font: font-label, size: size-label, alignment: alignment, stroke: stroke)
  }

  // Renders an input-style value field with a bottom border.
  let value(content, alignment: center, stroke: none) = {
    let stroke = if stroke == none { (bottom: 0.5pt + black) } else { stroke }
    // let content = text(content, bottom-edge: "descender", ..args)

    cell-base(content, font: font-value, size: size-value, alignment: alignment, stroke: stroke)
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

  return (
    label: label,
    value: value,
    row: row,
    rows: rows,
  )
}
