require 'time'
start = Time.now

def template
  File.read(File.expand_path(File.join(__dir__, '..', 'templates', 'doc.html')))
end

def partial(type:, values: {})
  partial = File.read(File.expand_path(File.join(__dir__, '..', 'templates', "partial-#{type}.html")))
  partial % values
end

def write_page(type:, content:)
  path = File.expand_path(File.join(__dir__, '..', 'pages', "#{type}.html"))
  File.write(path, content)
end

title = 'Correlation between life expectancy, fertility rate'
h_axis_title = 'Life Expectancy'
v_axis_title = 'Fertility Rate'
array_data_table = [
  ['ID', h_axis_title, v_axis_title, 'Region',     'Population'],
  ['CAN',    80.66,              1.67,      'North America',  33739900],
  ['DEU',    79.84,              1.36,      'Europe',         81902307],
  ['DNK',    78.6,               1.84,      'Europe',         5523095],
  ['EGY',    72.73,              2.78,      'Middle East',    79716203],
  ['GBR',    80.05,              2,         'Europe',         61801570],
  ['IRN',    72.49,              1.7,       'Middle East',    73137148],
  ['IRQ',    68.09,              4.77,      'Middle East',    31090763],
  ['ISR',    81.55,              2.96,      'Middle East',    7485600],
  ['RUS',    68.6,               1.54,      'Europe',         141850000],
  ['USA',    78.09,              2.05,      'North America',  307007000]
]

type    = 'bubble'
values  = { title: title, array_data_table: array_data_table, h_axis_title: h_axis_title, v_axis_title: v_axis_title }
partial = partial(type: type, values: values)
content = template % { partial: partial }

write_page(type: type, content: content)
puts "done in #{Time.now - start}s"
