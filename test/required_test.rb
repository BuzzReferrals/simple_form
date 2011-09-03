require 'test_helper'

# Tests for f.input with required attribute
class RequiredTest < ActionView::TestCase
  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  # REQUIRED AND PRESENCE VALIDATION
  test 'builder input should obtain required from ActiveModel::Validations when it is included' do
    with_form_for @validating_user, :name
    assert_select 'input.required[required]#validating_user_name'
    with_form_for @validating_user, :status
    assert_select 'input.optional#validating_user_status'
  end

  test 'builder input should allow overriding required when ActiveModel::Validations is included' do
    with_form_for @validating_user, :name, :required => false
    assert_select 'input.optional#validating_user_name'
    with_form_for @validating_user, :status, :required => true
    assert_select 'input.required[required]#validating_user_status'
  end

  test 'builder input should be required by default when ActiveModel::Validations is not included' do
    with_form_for @user, :name
    assert_select 'input.required[required]#user_name'
  end

  test 'builder input should not be required by default when ActiveModel::Validations is not included if option is set to false' do
    swap SimpleForm, :required_by_default => false do
      with_form_for @user, :name
      assert_select 'input.optional#user_name'
      assert_no_select 'input[required]'
    end
  end

  test 'builder input should allow disabling required when ActiveModel::Validations is not included' do
    with_form_for @user, :name, :required => false
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#user_name'
  end

  # VALIDATORS :if :unless
  test 'builder input should not be required when ActiveModel::Validations is included and if option is present' do
    with_form_for @validating_user, :age
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_age'
  end

  test 'builder input should not be required when ActiveModel::Validations is included and unless option is present' do
    with_form_for @validating_user, :amount
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_amount'
  end

  # VALIDATORS :on
  test 'builder input should be required when validation is on create and is not persisted' do
    @validating_user.new_record!
    with_form_for @validating_user, :action
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_action'
  end

  test 'builder input should not be required when validation is on create and is persisted' do
    with_form_for @validating_user, :action
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_action'
  end

  test 'builder input should be required when validation is on save' do
    with_form_for @validating_user, :credit_limit
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_credit_limit'

    @validating_user.new_record!
    with_form_for @validating_user, :credit_limit
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_credit_limit'
  end

  test 'builder input should be required when validation is on update and is persisted' do
    with_form_for @validating_user, :phone_number
    assert_select 'input.required'
    assert_select 'input[required]'
    assert_select 'input.required[required]#validating_user_phone_number'
  end

  test 'builder input should not be required when validation is on update and is not persisted' do
    @validating_user.new_record!
    with_form_for @validating_user, :phone_number
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_select 'input.optional#validating_user_phone_number'
  end
end