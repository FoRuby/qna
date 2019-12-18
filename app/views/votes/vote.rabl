object @votable => :votable
attributes :id, :rating
node(:name) { @votable.class.name.downcase }
