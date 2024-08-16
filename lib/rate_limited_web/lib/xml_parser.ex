defmodule RateLimtedWeb.XmlParser do
  import SweetXml

  def parse_xml(xml_file) do
    msg_id = xml_file |> xpath(~x"//MsgId/text()")
    IO.inspect(msg_id)
    msg_id
  end
end
