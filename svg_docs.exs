defmodule SvgDocs do
  @doc_path "./docs/svg_docs.html"

  def generate() do
    {:ok, content} = File.read("./assets/static/images/icons.svg")
    {:ok, [content]} = Floki.parse_fragment(content)

    content =
      content
      |> Floki.children()
      |> Floki.raw_html(pretty: true)

    if File.dir?("./docs/") === false, do: File.mkdir!("./docs")
    File.touch(@doc_path)
    File.write!(@doc_path, html(content))

    IO.puts("\n Docs created successfully! \n Path: #{@doc_path}")
    {:ok, path} = File.cwd()

    IO.puts(
      "\n Open the following path in your browser to view the doc: \n #{path}#{String.slice(@doc_path, 1..-1)} \n"
    )
  end

  defp js() do
    """
    body = document.querySelector("body");
    svgs = body.querySelectorAll("svg");
    // fetch ids of all svgs and create a div to store them along with them

    svgs.forEach((svg) => {
      // let svg = svgs[i];
      let id = svg.id;
      let parentDiv = document.createElement("div");
      let svgName = document.createElement("div");
      parentDiv.appendChild(svg);
      parentDiv.appendChild(svgName);
      svgName.innerText = id;
      body.appendChild(parentDiv);
    })
    """
  end

  defp css() do
    """
    svg {
      display: block;
      max-height: 70px;
      height: 100%;
      max-width: 70px;
    }
    body {
      padding: 30px;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      grid-auto-rows: 1fr;
      /* flex-direction: row;
      flex-wrap: wrap; */
      gap: 50px;
    }
    body > div {
      padding: 20px;
      border-radius: 10px;
      background-color: rgb(212, 212, 212);
      width: 110px;
      height: 110px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      gap: 10px;
    }
    """
  end

  defp html(content) do
    """
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <style>
          #{css()}
        </style>
      </head>
      <body>
      #{content}
          <script>
      #{js()}
        </script>
      </body>
    </html>
    """
  end
end

SvgDocs.generate()
