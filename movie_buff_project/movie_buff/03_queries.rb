def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie
    .select(:id, :title)
    .joins(:actors)
    .where(actors: {name: those_actors})
    .group(:id)
    .having("COUNT(*) = :num_actors", num_actors: those_actors.length)

end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
    .group("decade")
    .order("AVG(score) DESC")
    .limit(1)
    .pluck("(yr - (yr % 10)) AS decade")
    .first

end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery

  Actor
    .joins("INNER JOIN castings AS cast1 ON cast1.actor_id = actors.id")
    .joins("INNER JOIN castings AS cast2 ON cast1.movie_id = cast2.movie_id")
    .joins("INNER JOIN actors AS costars ON cast2.actor_id = costars.id")
    .group("actors.id")
    .where("actors.name != :name AND costars.name = :name", name: name)
    .pluck(:name)
end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor
    .left_outer_joins(:movies)
    .where("movies.id IS NULL")
    .count(:id)
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.
  str_match = '%' + whazzername.chars.join('%') + '%'

  Movie
    .joins(:actors)
    .where("LOWER (actors.name) LIKE ?", str_match)

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"

end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.

  Actor
    .select(:id, :name, "MAX(movies.yr) - MIN(movies.yr) AS career")
    .joins(:movies)
    .group(:id)
    .order("career DESC")
    .limit(3)
    

end
