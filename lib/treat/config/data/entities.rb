{
  list:
    [:entity, :unknown, :email,
      :url, :symbol, :sentence,
      :punctuation, :number,
      :enclitic, :word, :token,
      :fragment, :phrase, :paragraph,
      :title, :zone, :list, :block,
      :page, :section, :collection,
    :document],
  order:
    [:token, :fragment, :phrase,
      :sentence, :zone, :section,
    :document, :collection]
}