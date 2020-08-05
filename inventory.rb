class Inventory
  attr_reader :mouse_locked, :inventory, :image_name
  attr_accessor :clone_from_source_state

  def initialize(opts)
    @@tile = 0
    @opts = opts

    @image_name = @opts[:image]
    @mouse_locked = @opts[:mouse_locked] ||= false
    @mouse_x_drag_diff = @opts[:mouse_x_drag_diff] ||= 0
    @mouse_y_drag_diff = @opts[:mouse_y_drag_diff] ||= 0
    # Is this a source object or destination?
    @inventory = @opts[:inventory] ||= false
    @clone_from_source_state = false

    @source_char = nil

    @house = Sprite.new(
      @opts[:image],
      x: @opts[:x],
      y: @opts[:y],
      z: @play_area ? 2 : 1,
      width: TILE_SIZE,
      height: TILE_SIZE
    )
    @@tile += 1
  end

  def am_selected?
    return @house.contains?(Ruby2D::Window.get(:mouse_x), Ruby2D::Window.get(:mouse_y))
  end

  # def is_mouse_inside?
  #   # Hover Mouse over
  #   @house.contains?(Ruby2D::Window.get(:mouse_x), Ruby2D::Window.get(:mouse_y)) ? @house.opacity = 1.0 : @house.opacity = 0.5 if @inventory
  #
  #   # Clone from this source
  #   if @house.contains?(Ruby2D::Window.get(:mouse_x), Ruby2D::Window.get(:mouse_y)) && @inventory && $mouse_drag_state == MOUSE_CLICKED && @clone_from_source_state == false
  #     # @mouse_locked = true
  #     @clone_from_source_state = true
  #     @mouse_x_drag_diff = Ruby2D::Window.get(:mouse_x) - @house.x
  #     @mouse_y_drag_diff = Ruby2D::Window.get(:mouse_y) - @house.y
  #     puts "I got teh click..."
  #     return ret = {
  #       image: @image_name,
  #       event: TILE_EVENT_CREATE_COPY,
  #       x: @house.x,
  #       y: @house.y,
  #       mouse_x_drag_diff: @mouse_x_drag_diff,
  #       mouse_y_drag_diff: @mouse_y_drag_diff
  #     }
  #   end
  #
  #   # if @mouse_locked && $mouse_drag_state == MOUSE_CLICKED
  #   #   desired_x = Ruby2D::Window.get(:mouse_x) - @mouse_x_drag_diff
  #   #   desired_y = Ruby2D::Window.get(:mouse_y) - @mouse_y_drag_diff
  #   #
  #   #   @house.x = (desired_x/TILE_SIZE).to_i * TILE_SIZE
  #   #   @house.y = (desired_y/TILE_SIZE).to_i * TILE_SIZE
  #   # end
  #
  #   if @mouse_locked
  #     desired_x = Ruby2D::Window.get(:mouse_x) - @mouse_x_drag_diff
  #     desired_y = Ruby2D::Window.get(:mouse_y) - @mouse_y_drag_diff
  #
  #     @house.x = (desired_x/TILE_SIZE).to_i * TILE_SIZE
  #     @house.y = (desired_y/TILE_SIZE).to_i * TILE_SIZE
  #   end
  #
  #   if @mouse_locked && $mouse_drag_state == MOUSE_DRAG_END && @house.y >= TILE_SIZE*4
  #     # Mouse up done here
  #     @mouse_locked = false
  #     puts "#{@@tile} Landed at: #{@house.x},#{@house.y}"
  #   end
  #
  #   return ret = {
  #     event: TILE_EVENT_NONE
  #   }
  # end
end
