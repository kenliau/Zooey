module DocumentationsHelper

  def documentation_permalink(document)
    "/guide/#{document.permalink}"
  end

end
