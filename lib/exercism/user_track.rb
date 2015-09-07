require_relative 'user_track_queries'

class UserTrack
  extend UserTrack::Queries

  class UserProblem
    include Named

    attr_reader :slug, :total, :unread
    def initialize(slug, total, viewed)
      @slug = slug
      @total = total
      @unread = total-viewed
    end
  end

  def self.all_for(user)
    totals = exercise_counts_per_track(user.id)
    views = viewed_counts_per_track(user.id)
    track_ids = (totals.keys + views.keys).uniq
    tracks = track_ids.each_with_object([]) do |track_id, user_tracks|
      user_tracks << new(track_id, totals[track_id], views[track_id])
    end
    tracks.sort_by(&:id)
  end

  def self.problems_for(user, track_id)
    totals = problem_counts_in_track(user.id, track_id)
    views = viewed_counts_in_track(user.id, track_id)
    slugs = (totals.keys + views.keys).uniq
    problems = slugs.each_with_object([]) do |slug, user_problems|
      user_problems << UserProblem.new(slug, totals[slug], views[slug])
    end
    problems
  end

  attr_reader :id, :total, :unread, :name
  def initialize(id, total, viewed)
    @id = id
    @total = total
    @unread = total.to_i-viewed.to_i
    @name = Language.of(id)
  end
end