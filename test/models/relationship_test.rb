require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:lana).id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require a follower_id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a followed_id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test 'should follow and unfollow a user' do # methods follow and unfollow and .following?
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test 'should be followed by a user' do # methods follow and unfollow and .following?
    michael = users(:michael)
    archer = users(:archer)
    assert_not archer.followed_by?(michael)
    michael.follow(archer)
    assert archer.followed_by?(michael)
    michael.unfollow(archer)
    assert_not archer.followed_by?(michael)
  end
end
