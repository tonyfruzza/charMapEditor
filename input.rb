$tile_in_hand     = false
$mouse_is_down    = false

on :key_up do |e|
  if e.key == 's'
    puts JSON.generate($canvas_array)
  end
end

on :mouse_down do |e|
  $mouse_is_down = true
  register_charcter
end

on :mouse_up do |e|
  # puts "#{e.x}, #{e.y}"
  $mouse_is_down = false
  @tile_objects.each do |t|
    if t.am_selected?
      if $active_tile_type != t.image_name
        $active_tile_type = t.image_name
        puts "new type is selected #{t.image_name}"
      end
    end
  end
end

on :mouse_move do |e|
  register_charcter
  unless $mouse_down
    if $canvas_area.contains?(Ruby2D::Window.get(:mouse_x), Ruby2D::Window.get(:mouse_y))
      desired_x = Ruby2D::Window.get(:mouse_x)
      desired_y = Ruby2D::Window.get(:mouse_y)

      $place_holder_box.x = (desired_x/TILE_SIZE).to_i * TILE_SIZE
      $place_holder_box.y = (desired_y/TILE_SIZE).to_i * TILE_SIZE
    else
      $place_holder_box.x = 0 - TILE_SIZE
      $place_holder_box.y = 0 - TILE_SIZE
    end
  end

end
