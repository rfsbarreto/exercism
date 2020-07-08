defmodule RobotSimulator do
  defstruct direction: :north, position: {0, 0}

  @doc """
  Process movement from a given robot direction/position and a instruction movement
  """
  @spec process_movement(robot :: any, movement :: String.t()) :: any
  def process_movement(%RobotSimulator{direction: :north} = robot, "L"),
    do: %RobotSimulator{robot | direction: :west}

  def process_movement(%RobotSimulator{direction: :west} = robot, "L"),
    do: %RobotSimulator{robot | direction: :south}

  def process_movement(%RobotSimulator{direction: :south} = robot, "L"),
    do: %RobotSimulator{robot | direction: :east}

  def process_movement(%RobotSimulator{direction: :east} = robot, "L"),
    do: %RobotSimulator{robot | direction: :north}

  def process_movement(%RobotSimulator{direction: :north} = robot, "R"),
    do: %RobotSimulator{robot | direction: :east}

  def process_movement(%RobotSimulator{direction: :west} = robot, "R"),
    do: %RobotSimulator{robot | direction: :north}

  def process_movement(%RobotSimulator{direction: :south} = robot, "R"),
    do: %RobotSimulator{robot | direction: :west}

  def process_movement(%RobotSimulator{direction: :east} = robot, "R"),
    do: %RobotSimulator{robot | direction: :south}

  def process_movement(%RobotSimulator{direction: :north, position: {x, y}} = robot, "A"),
    do: %RobotSimulator{robot | position: {x, y + 1}}

  def process_movement(%RobotSimulator{direction: :west, position: {x, y}} = robot, "A"),
    do: %RobotSimulator{robot | position: {x - 1, y}}

  def process_movement(%RobotSimulator{direction: :south, position: {x, y}} = robot, "A"),
    do: %RobotSimulator{robot | position: {x, y - 1}}

  def process_movement(%RobotSimulator{direction: :east, position: {x, y}} = robot, "A"),
    do: %RobotSimulator{robot | position: {x + 1, y}}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create() :: any
  def create() do
    %RobotSimulator{}
  end

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction, _) when direction not in [:north, :east, :south, :west] do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y} = position) when is_number(x) and is_number(y) do
    %RobotSimulator{direction: direction, position: position}
  end

  def create(_, _) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) when is_binary(instructions) do
    case String.next_grapheme(instructions) do
      {current, ""} ->
        robot
        |> process_movement(current)

      {current, remaining} when current in ["L", "R", "A"] ->
        robot
        |> process_movement(current)
        |> simulate(remaining)

      _ ->
        {:error, "invalid instruction"}
    end
  end

  def simulate(_, _) do
    {:error, "invalid instruction"}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
