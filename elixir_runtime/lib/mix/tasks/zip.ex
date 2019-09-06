# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

defmodule Mix.Tasks.Zip do
  use Mix.Task

  @shortdoc "zip the contents of the current release"
  def run(_) do
    app = app_name()
    version = app_version()
    path = release_path(app)
    {:ok, cwd} = File.cwd()

    cmd = "cd #{path} && \
    chmod +x bin/#{app} && \
    chmod +x releases/#{version}/elixir && \
    chmod +x erts-*/bin/erl && \
    zip -r lambda.zip * && \
    cp lambda.zip #{cwd}"

    System.cmd("sh", ["-c", cmd])
  end

  defp app_name() do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string
  end

  defp app_version() do
    Mix.Project.config()
    |> Keyword.fetch!(:version)
    |> to_string
  end

  defp release_path(app) do
    "_build/#{Mix.env()}/rel/#{app}/"
  end
end
