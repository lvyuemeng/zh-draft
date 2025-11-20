#import "@preview/pointless-size:0.1.2": zh
#import "@preview/cuti:0.4.0": *
#import "../lib.typ": *

#let cover(
  // --- Content Arguments ---
  title: ("The Modular Design of Cover", "Based on Typst"),
  author: "Bob",
  student-id: "1234567890",
  grade: "20XX",
  department: "XX",
  major: "XX",
  supervisor: ("XX", "Professor"),
  supervisor-ii: none,
  submit-date: datetime.today(),
  // --- Configuration Arguments ---
  anonymous: false,
  twoside: false,
  min-title-lines: 2,
  // Fonts & Styling
  fonts: (
    title: "SimSun",
    key: "KaiTi",
    value: "SimSun",
  ),
  sizes: (
    title: 26pt,
    key: 16pt,
    value: 16pt,
  ),
) = {
  let date = utils.format-date(submit-date)
  let safe-author = utils.mask-field(author, anonymous)
  let safe-id = utils.mask-field(student-id, anonymous)
  let safe-grade = utils.mask-field(grade, anonymous)

  let theme = components.field-theme(
    font-label: fonts.key,
    font-value: fonts.value,
    size-label: sizes.key,
    size-value: sizes.value,
  )

  pagebreak(weak: true, to: if twoside { "odd" })
  set align(center + horizon)

  block(width: 100%, height: 100%)[
    // Title Section
    #text(
      size: sizes.title,
      font: fonts.title,
      weight: "bold",
      spacing: 1em,
    )[#fakebold[毕 业 论 文]]

    #v(60pt)

    // Information Grid
    #block(width: 320pt)[
      #grid(
        columns: (72pt, 1fr, 72pt, 1fr),
        column-gutter: 0pt,
        row-gutter: 12pt,

        // --- Standard Fields ---
        ..(theme.row)("院　　系", department, col-val: 3),
        ..(theme.row)("专　　业", major, col-val: 3),

        // Dynamic Title Rows
        ..(theme.rows)("题    目", title, col-val: 3),

        ..(theme.row)("年　　级", safe-grade),
        ..(theme.row)("学　　号", safe-id),

        ..(theme.row)("学生姓名", safe-author, val-args: (weight: "bold"), col-val: 3),

        ..(theme.row)("指导教师", supervisor.at(0)),
        ..(theme.row)("职　　称", supervisor.at(1)),

        ..if supervisor-ii != none {
          ((theme.row)("第二导师", supervisor-ii.at(0)), (theme.row)("职   称", supervisor-ii.at(1))).flatten()
        } else { () },

        ..(theme.row)("提交日期", date, col-val: 3)
      )
    ]
  ]
}

#cover(
  title: ("The Modular Design of Cover", "Based on Typst"),
  author: "Alice",
  student-id: "20210001",
  department: "XX",
  major: "XX",
  supervisor: ("John", "教授"),
  supervisor-ii: ("Bob", "副教授"),
)
