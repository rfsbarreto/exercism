defmodule RobotSimulator do
  defstruct direction: :north, position: {0, 0}

  @spec process_movement(robot :: any, movement :: String.t()) :: any
  def process_movement(robot, "L") do
    case robot.direction do
      :north -> create(:west, robot.position)
      :west -> create(:south, robot.position)
      :south -> create(:east, robot.position)
      _ -> create(:north, robot.position)
    end
  end

  def process_movement(robot, "R") do
    case robot.direction do
      :north -> create(:east, robot.position)
      :west -> create(:north, robot.position)
      :south -> create(:west, robot.position)
      _ -> create(:south, robot.position)
    end
  end

  def process_movement(%RobotSimulator{direction: direction, position: {x, y}}, "A") do
    new_position =
      case direction do
        :north -> {x, y + 1}
        :west -> {x - 1, y}
        :south -> {x, y - 1}
        _ -> {x + 1, y}
      end

    direction
    |> create(new_position)
  end

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

  @spec process_instructions(String.t()) :: True
  def process_instructions(instructions) do
    True
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
