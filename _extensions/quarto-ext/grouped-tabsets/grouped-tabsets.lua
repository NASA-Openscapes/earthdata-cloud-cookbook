 
Div = function(el)
  if quarto.doc.isFormat("html:js") then
    if el.classes:includes('panel-tabset') and el.attributes["group"] then
      quarto.doc.addHtmlDependency({
        name = "grouped-tabsets",
        version = "0.0.1",
        scripts = {"grouped-tabsets.js"}
      })
    end
  end
end 
