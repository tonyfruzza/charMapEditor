require 'ruby2d'
require 'json'
require 'optparse'
require './inventory.rb'
require './input.rb'

set title: 'tilemap8x8'
set resizable: true

TILE_EVENT_NONE = 0
TILE_EVENT_CREATE_COPY = 1
TILE_SIZE = 16
CANVAS_VERTICAL_TILE_OFFSET_COUNT = 4
CHAR_PREFIX = 'tiles/tile-'
CHAR_EXTENSION = '.bmp'
# CHAR_BLANK = 32
CHAR_BLANK = 67

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: tileapp.rb [options]"
  opts.on('-f', '--file FILE.JSON', 'read in file as config'){|o| options[:file] = o}
end.parse!

$active_tile_type = nil
if options[:file]
  puts "loading config from file..."
  $canvas_array = JSON.parse(File.read(options[:file]))
else
  $canvas_array = []
  (0..24).each do |y|
    $canvas_array[y] = []
    (0..39).each do |x|
      $canvas_array[y][x] = CHAR_BLANK
    end
  end
end

(0..24).each do |y|
  (0..39).each do |x|
    Sprite.new(
      "#{CHAR_PREFIX}#{$canvas_array[y][x]}#{CHAR_EXTENSION}",
      x: x * TILE_SIZE,
      y: (y + CANVAS_VERTICAL_TILE_OFFSET_COUNT) * TILE_SIZE,
      z: 2,
      width: TILE_SIZE,
      height: TILE_SIZE
    )
  end
end


Rectangle.new(x: 0, y: 0, width: 640, height: 480, color: 'gray')
$canvas_area = Rectangle.new(x: 0, y: TILE_SIZE*CANVAS_VERTICAL_TILE_OFFSET_COUNT, width: TILE_SIZE*40, height: TILE_SIZE*25, color: 'black')

$place_holder_box = Rectangle.new(x: 0, y: 0, width: TILE_SIZE, height: TILE_SIZE, color: 'gray', opacity: 0.5, z: 10)

# convert outbreak_chars.bmp +adjoin -crop 8x8 tile.bmp
@tile_objects = []
(0..127).each do |x|
  @tile_objects << Inventory.new(
    {
      mouse_locked: false,
      inventory: true,
      image: "tiles/tile-#{x}.bmp",
      x: (x % 40) * TILE_SIZE + 1,
      y: (x/40 * TILE_SIZE).to_i + 1
    }
  )
end

def register_charcter()
  return unless $mouse_is_down
  if $canvas_area.contains?(Ruby2D::Window.get(:mouse_x), Ruby2D::Window.get(:mouse_y))
    desired_x = Ruby2D::Window.get(:mouse_x)
    desired_y = Ruby2D::Window.get(:mouse_y)

    if $active_tile_type
      begin
        if $canvas_array[(desired_y/TILE_SIZE).to_i - CANVAS_VERTICAL_TILE_OFFSET_COUNT][(desired_x/TILE_SIZE).to_i] != $active_tile_type[/\d+/].to_i
          Sprite.new(
            $active_tile_type,
            x: (desired_x/TILE_SIZE).to_i * TILE_SIZE,
            y: (desired_y/TILE_SIZE).to_i * TILE_SIZE,
            z: 2,
            width: TILE_SIZE,
            height: TILE_SIZE
          )
        end
        $canvas_array[(desired_y/TILE_SIZE).to_i - CANVAS_VERTICAL_TILE_OFFSET_COUNT][(desired_x/TILE_SIZE).to_i] = $active_tile_type[/\d+/].to_i
      rescue
        return nil
      end
    end
  end
end


update do
  in_clone_mode = false
  @tile_objects.each do |t|
    # ret = t.is_mouse_inside?
    # if TILE_EVENT_CREATE_COPY == ret[:event]
    #   @tile_objects << Inventory.new(
    #     {
    #       image: ret[:image],
    #       mouse_locked: true,
    #       x: ret[:x],
    #       y: ret[:y],
    #       mouse_x_drag_diff: ret[:mouse_x_drag_diff],
    #       mouse_y_drag_diff: ret[:mouse_y_drag_diff]
    #     }
    #   )
    # end
    # in_clone_mode = t if t.clone_from_source_state
  end
  # Are we in a drag clone drag state?
  # if in_clone_mode
  #   in_clone_mode.clone_from_source_state = false unless @tile_objects.find{|i| i.mouse_locked}
  # end
end

show
