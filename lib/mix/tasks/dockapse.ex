defmodule Mix.Tasks.Dockapse.Build do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to build from a dockerfile with a tag.

  Usage:
  `$ mix dockapse.build --f <path-to-dockerfile> --t <image-tag> `
  """

  @switches [f: :string, t: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[f: dockerfile, t: tag], _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.build(dockerfile, tag, true)
  end
end

defmodule Mix.Tasks.Dockapse.Cp do
  use Mix.Task

  @moduledoc """
  Mix task that can be to copy files from a container to destination.

  Usage:
  `$ mix dockapse.cp --continer <contianer-id-or-tag> --from <source> --to <destination> `
  """

  @switches [container: :string, from: :string, to: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[container: cid, from: source, to: dest], _, _} =
      OptionParser.parse(argv, switches: @switches)

    Dockapse.cp(cid, source, dest, true)
  end
end

defmodule Mix.Tasks.Dockapse.Ps do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to list all the containers.

  Usage:
  - `$ mix dockapse.ps --all` : Lists all containers
  - `$ mix dockapse.ps` : Lists active containers
  """

  @switches [all: :boolean]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.ps(opts[:all], true)
  end
end

defmodule Mix.Tasks.Dockapse.Images do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to list all the images.

  Usage:
  `$ mix dockapse.images`
  """

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(_), do: Dockapse.images(true)
end

defmodule Mix.Tasks.Dockapse.Create do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to create a container from an image.

  Usage:
  `$ mix dockapse.create --image <image-name> --name <container-name>`
  or
  `$ mix dockapse.create --image <image-name>` : Container will have no name
  """

  @switches [image: :string, name: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[image: image] = opts, _, _} = OptionParser.parse(argv, switches: @switches)

    case opts[:name] do
      nil -> Dockapse.create(image, nil, true)
      name -> Dockapse.create(image, name, true)
    end
  end
end

defmodule Mix.Tasks.Dockapse.Rm do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to remove a container.

  Usage:
  `$ mix dockapse.remove --container <container-id-or-name>`
  """

  @switches [container: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[container: cid], _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.rm(cid, true)
  end
end

defmodule Mix.Tasks.Dockapse.Rmi do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to remove an image.

  Usage:
  `$ mix dockapse.rmi --image <image-id-or-tag>`
  """

  @switches [image: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[image: image_id], _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.rmi(image_id, true)
  end
end

defmodule Mix.Tasks.Dockapse.Tag do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to tag an image.

  Usage:
  `$ mix dockapse.tag --image <image-id-or-tag> --tag <tag-name>`
  """

  @switches [image: :string, tag: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[image: image, tag: tag], _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.tag(image, tag, true)
  end
end

defmodule Mix.Tasks.Dockapse.Push do
  use Mix.Task

  @moduledoc """
  Mix task that can be used to push an image to remote.

  Usage:
  `$ mix dockapse.push --image <image-name-or-tag> --tag <tag-to-push-by>`
  """

  @switches [image: :string]

  @doc """
  Delegates the arguments to Dockapse and prints the output
  """
  def run(argv) do
    {[image: image], _, _} = OptionParser.parse(argv, switches: @switches)

    Dockapse.push(image, true)
  end
end
