module UsersHelper
  attr_accessor :logger #= Logger.new("#{Rails.root}/log/cache_read.log")
  # constants:
  MATCH_PERCENT_LIMIT = 0.0#0.60
  MAX_DEGREE = 5
  MAX_IMPORTANCE = 5

#   def setup
#     @logger = Logger.new("#{Rails.root}/log/cache_read.log")
#     @logger.debug "Logger setup"
#   end


  # helping classes:

  # =============================
  class MatchScore
    attr_accessor :points
    attr_accessor :total_importance
    attr_accessor :user_scored
    attr_accessor :unanswered_req_total_importance


    def initialize(all_reqs, user_with_stats, all_stats)
      @points = 0
      @total_importance = 0
      @unanswered_req_total_importance = 0
      compatable = true

      @user_scored = user_with_stats

#       user_with_reqs.custom_statements = user_with_reqs.CustomStatement.all
#       user_with_stats.custom_statements = user_with_stats.CustomStatement.all

      # for each requirement...
#       user_with_reqs.custom_statements.each do |req|
      all_reqs.each do |req|

        related_stat = get_related_stat(req, all_stats)

        @logger = Logger.new("#{Rails.root}/log/cache_read.log")
        @logger.debug "looking at req = #{req.statement}"

#         related_stat = user_with_stats.get_stat_from_question(req.get_question)

        # if is a filter & not met, done & score is zero:
        if !req_met?(req, related_stat)
          compatable = false
#           @logger = Logger.new("#{Rails.root}/log/cache_read.log")
          @logger.debug "imcompatable @ req = #{req.statement}"
          break
        # if this requirement is NOT a filter requirement, grade normally:
        else
          @total_importance += req.importance

          grade_stat_against_req(related_stat,req)
        end#if end.
      end#do end.

      if !compatable
        @points = 0
        @unanswered_req_total_importance = 0
      end#if end.
    end#method end.

    def get_related_stat(req, all_stats)
      related_stat = nil
      all_stats.each do |stat|
        if stat.statement == req.statement
          @logger = Logger.new("#{Rails.root}/log/cache_read.log")
          @logger.debug "found related stat!: #{req.statement} == #{stat.statement}"
          related_stat = stat
        end #if end.
      end #do end.
      return related_stat
    end#method end.

    # meat of the algorithm:
    def grade_stat_against_req(stat, req)
      # case that other user has NOT answered this question:
      if stat.nil?
        @unanswered_req_total_importance += req.importance

        @logger = Logger.new("#{Rails.root}/log/cache_read.log")
        @logger.debug "unanswered question @ req = #{req.statement}"
      # case that other user has answered this question:
      else
        @points += (req.importance * stat.degree_of_truth)

        @logger = Logger.new("#{Rails.root}/log/cache_read.log")
        @logger.debug "grade for #{req.statement} = #{req.importance} * #{stat.degree_of_truth}"
      end#if end.
    end#method end.



    def req_met?(req, stat)
      if req.importance < 0 # must NOT have/be:
        return (stat.nil? || stat.degree_of_truth == 0)

      elsif req.importance > MAX_IMPORTANCE # MUST have/be
        return (!stat.nil? && stat.degree_of_truth != 0)

      else
        return true # not a filter req.
      end#if end.
    end#method end.



    def get_raw_total
      return @points
    end



    def get_max_potential

      return get_raw_total + (@unanswered_req_total_importance * MAX_DEGREE)
    end

    def get_average(num1,num2)
      return (num1 + num2) / 2;
    end


    def get_position
      @logger = Logger.new("#{Rails.root}/log/cache_read.log")

      avg =  get_average(get_raw_total, get_max_potential);

      @logger.debug "get_position = avg: raw total(#{get_raw_total}), max potential(#{get_max_potential} = avg(#{avg}))"

      return avg
    end


    def get_total_possible_points
      @logger = Logger.new("#{Rails.root}/log/cache_read.log")
      @logger.debug "get_total_possible_points = tot importance(#{@total_importance}) * MAX_DEGREE(#{MAX_DEGREE})"
      return @total_importance * MAX_DEGREE
    end
  end#class end.





  # =============================
  class TwoSidedMatchScore
    attr_accessor :match_score_A_to_B
    attr_accessor :match_score_B_to_A

    def initialize (match_score_this_to_other, match_score_other_to_this)
      @match_score_A_to_B = match_score_this_to_other
      @match_score_B_to_A = match_score_other_to_this
    end


    def get_match_rate
      @logger = Logger.new("#{Rails.root}/log/cache_read.log")
      @logger.debug "getting final match rate for #{@match_score_A_to_B.user_scored.email} & #{@match_score_B_to_A.user_scored.email}"


      position_sum = @match_score_A_to_B.get_position + @match_score_B_to_A.get_position;
      @logger.debug "position_sum = #{position_sum}"

      total_possible_sum = @match_score_A_to_B.get_total_possible_points + @match_score_B_to_A.get_total_possible_points;
      @logger.debug "total_possible_sum = #{total_possible_sum}"

      if total_possible_sum == 0
        @logger.debug "divide by zero b/c total_possible_sum == 0"
        return 0 # divide by zero rare case.
      else
        @logger.debug "match rate calc: position_sum(#{position_sum}) / total_possible_sum(#{total_possible_sum}) %"
        final_match_rate =  0.0 + (position_sum * 1.0) / (total_possible_sum * 1.0); #DEBUG: *100

        @logger.debug "final_match_rate = #{final_match_rate}"

        return final_match_rate * 100
      end
    end
  end


  # =============================
  class MatchedUser
    attr_accessor :match_rate
    attr_accessor :user

    def initialize(rate,user_entered)
      @match_rate = rate
      @user = user_entered
    end

    # use <=> operation for sorting the array automatically based on match rate:
    def <=>(other)
      @logger = Logger.new("#{Rails.root}/log/cache_read.log")
    @logger.debug "--sort: comparing: #{other.match_rate} vs #{@match_rate}"
      return (other.match_rate <=> @match_rate)
    end
  end



  # main behavior:

  # =============================
  def get_potential_matches(this_user)
      list_of_match_users = Array.new
      #     list_of_match_users = User.all
      #     if this_user != nil
      #       list_of_match_users << this_user # DEBUG
      #     end
#     logger = Logger.new("#{Rails.root}/log/cache_read.log")
    @logger = Logger.new("#{Rails.root}/log/cache_read.log")
    @logger.debug "STARTING Find Match"
    @logger.debug "inside get_potential_matches"

      @users = User.all

    #setup


      @users.each do |other_user|

        @logger.debug "comparing to user: #{other_user.email}"

        if (this_user != other_user)

          this_to_other_match_score = MatchScore.new(this_user.custom_statements, other_user, other_user.custom_statements)

          @logger.debug "this_to_other_match_score.points = #{this_to_other_match_score.points}"

          other_to_this_match_score = MatchScore.new(other_user.custom_statements, this_user, this_user.custom_statements)

          @logger.debug "other_to_this_match_score.points = #{other_to_this_match_score.points}"

          combined_match_score = TwoSidedMatchScore.new(this_to_other_match_score,other_to_this_match_score)

          final_match_rate = combined_match_score.get_match_rate
          @logger.debug "combined_match_score.get_match_rate = #{final_match_rate}"

          if final_match_rate >= MATCH_PERCENT_LIMIT
            matched_user = MatchedUser.new(final_match_rate, other_user)

            @logger.debug "found a match! = #{matched_user.user.email}"

            list_of_match_users << matched_user
          end
        end

      end

      #     # sort based on match rate:
      list_of_match_users.sort # sorts in ascending order (0%->100%)
      list_of_match_users.reverse! # reverse to be in descending order (100%->0% match rate)
      @logger.debug "DONE with Find Match!!"
      return list_of_match_users
    end






end
