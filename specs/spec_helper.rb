# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'pdf/wrapper'
require 'tempfile'
require 'rubygems'

gem "pdf-reader", ">=0.6.1"

require 'pdf/reader'

# make some private methods of PDF::Wrapper public for testing
class PDF::Wrapper
  public :build_pango_layout
  public :calc_image_dimensions
  public :load_librsvg
  public :load_libpixbuf
  public :load_libpango
  public :load_libpoppler
  public :default_text_options
  public :detect_image_type
  public :draw_pdf
  public :draw_pixbuf
  public :draw_png
  public :draw_svg
  public :validate_color
end

# a helper class for couting the number of pages in a PDF
class PageReceiver
  attr_accessor :page_count

  def initialize
    @page_count = 0
  end

  # Called when page parsing ends
  def end_page
    @page_count += 1
  end
end

class PageTextReceiver
  attr_accessor :content

  def initialize
    @content = []
  end

  # Called when page parsing starts
  def begin_page(arg = nil)
    @content << ""
  end

  def show_text(string, *params)
    @content.last << string.strip
  end

  # there's a few text callbacks, so make sure we process them all
  alias :super_show_text :show_text
  alias :move_to_next_line_and_show_text :show_text
  alias :set_spacing_next_line_show_text :show_text

  def show_text_with_positioning(*params)
    params = params.first
    params.each { |str| show_text(str) if str.kind_of?(String) }
  end

end
