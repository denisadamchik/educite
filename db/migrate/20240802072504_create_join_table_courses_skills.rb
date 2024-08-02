class CreateJoinTableCoursesSkills < ActiveRecord::Migration[7.1]
  def change
    create_join_table :courses, :skills do |t|
      t.index %i[course_id skill_id]
      t.index %i[skill_id course_id]
    end
  end
end
