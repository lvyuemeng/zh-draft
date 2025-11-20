#import "@preview/pointless-size:0.1.2": zh
#import "@preview/cuti:0.4.0": *
#import "../lib.typ": *

#let abstract(
  // --- Content Arguments ---
  title: none,
  author: none,
  department: none,
  major: none,
  supervisor: (),
  supervisor-ii: (),
  keywords: (),
  body,
  // --- Configuration Arguments ---
  anonymous: false,
  twoside: false,
  outline-title: "中文摘要",
  outlined: true,
  // Fonts & Styling
  fonts: (
    title: "SimSun",
    label: "KaiTi",
    body: "SimSun",
    header: "KaiTi",
  ),
  sizes: (
    header: 18pt,
    body: 12pt,
  ),
) = {
  // 1. Process Data
  let title = utils.join-by-sep(title)
  let keywords = utils.join-by-sep(keywords)

  let safe-author = utils.mask-field(author, anonymous)
  let safe-supervisor = utils.mask-field(supervisor.at(0) + supervisor.at(1), anonymous)
  let safe-supervisor-ii = if supervisor-ii != none {
    utils.mask-field(supervisor-ii.at(0) + supervisor-ii.at(1), anonymous)
  } else { none }

  // Render Layout
  pagebreak(weak: true, to: if twoside { "odd" })

  set text(font: fonts.label, size: sizes.body)
  set par(leading: 1.3em, spacing: 1.2em, justify: true)

  components.hidden-heading(outline-title, outlined: outlined)

  // Header Section
  align(center)[
    #text(font: fonts.header, size: sizes.header, weight: "bold")[
      #v(1em)
      #components.double-underline[
        #fakebold[XX 摘要]
      ]
    ]
  ]

  v(1em)

  par({
    fakebold("题目: ")
    text(font: fonts.body, {
      title
    })
  })
  par({
    fakebold("院系: ")
    text(font: fonts.body, {
      department
    })
  })
  par({
    fakebold("专业: ")
    text(font: fonts.body, {
      major
    })
  })
  par({
    fakebold("本科生姓名: ")
    text(font: fonts.body, {
      safe-author
    })
  })

  par({
    fakebold([指导教师（姓名、职称）：])
    text(font: fonts.body, {
      safe-supervisor
      if safe-supervisor-ii != none {
        h(1em)
        safe-supervisor-ii
      }
    })
  })

  fakebold([摘要：])

	{
		set par(first-line-indent: 2em)
		set text(font:fonts.body)
		body
	}
	
  v(1em)

  fakebold([关键词：])
  text(font: fonts.body)[#keywords]
}

#abstract(
  title: "基于 Typst 的模块化论文系统设计",
  author: "Alice",
  department: "XX",
  major: "XX",
  supervisor: ("John", "教授"),
  supervisor-ii: ("Bob", "讲师"),
  keywords: ("Typst", "排版系统", "模块化", "论文模板"),
  anonymous: false,
)[
  本文介绍了一种基于 Typst 的学位论文排版系统的设计与实现。针对传统 LaTeX 模板难以维护、编译速度慢等问题，本文提出了一套模块化的组件设计方案。

  通过解耦样式与内容，利用 Typst 强大的脚本能力，实现了封面、摘要、正文等部分的灵活配置。实验结果表明，该系统能够显著提高论文撰写的效率，同时保证了排版的规范性与美观度。

  这是一个测试段落，用于展示首行缩进的效果。Typst 的段落处理非常现代化，能够很好地处理中文排版中的各种边缘情况。
]
