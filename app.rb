require 'ruby2d'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
RECT_SIZE = 50
FRAME = 6
RECT_COLOR = "red"
BACKGROUND = "black"
BAR_LEN = 100
BAR_THICCNESS = 10
BAR_Y =  WINDOW_HEIGHT - BAR_THICCNESS - 100
BAR_COLOR= "blue"

class Point 
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = x
  end
end

def main
  set width: WINDOW_WIDTH, height: WINDOW_HEIGHT
  set title: "Pong Game"
  set background: BACKGROUND
  set borderless: 2
  set fullscreen: false

  song = Music.new('app.wav')
  song.loop = true
  song.volume = 20
  song.play

  proj_x = 100
  proj_y = 100
  proj_dx = 1
  proj_dy = 1

  bar_x = 0
  bar_y = BAR_Y - BAR_THICCNESS/2
  @proj_rect = Square.new(x: proj_x, y: proj_y, size: RECT_SIZE, color: RECT_COLOR)

  @barreact = Rectangle.new(x: bar_x, y: bar_y, width: BAR_LEN,
    height: BAR_THICCNESS, color: BAR_COLOR)

  update do

    proj_nx = proj_x + proj_dx * FRAME
    if proj_nx < 0 || proj_x + RECT_SIZE > WINDOW_WIDTH
      proj_dx = proj_dx * -1
      proj_nx = proj_x + proj_dx * FRAME
    end
    
    proj_ny = proj_y + proj_dy * FRAME
    if proj_ny < 0 || proj_y + RECT_SIZE > WINDOW_HEIGHT
      proj_dy = proj_dy * -1
      proj_ny = proj_y + proj_dy * FRAME
    end
    proj_x = proj_nx
    proj_y = proj_ny
    @proj_rect.x = proj_x
    @proj_rect.y = proj_y
  
  end

  on :key_held do |event|
    # A key was pressed
    key = event.key
    puts key
    case key
    when 'right'
        @barreact.x = @barreact.x + 10 if @barreact.x + BAR_LEN < WINDOW_WIDTH
    when 'left'
      @barreact.x = @barreact.x - 10 if @barreact.x > 0
    when 'a'
      exit
    end
  end
  show

end

# call main function
main
