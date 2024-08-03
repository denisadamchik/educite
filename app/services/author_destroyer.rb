class AuthorDestroyer
  def initialize(author)
    @author = author
  end

  def call
    reassign_courses
    destroy_author
  end

  private

  def reassign_courses
    new_author = Author.where.not(id: @author.id).sample

    if new_author
      @author.courses.find_each { _1.update!(author: new_author) }
    else
      @author.courses.destroy_all
    end
  end

  def destroy_author
    @author.destroy!
  end
end
