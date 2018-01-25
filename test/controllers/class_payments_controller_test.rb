require 'test_helper'

class ClassPaymentsControllerTest < ActionController::TestCase
  setup do
    @class_payment = class_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_payment" do
    assert_difference('ClassPayment.count') do
      post :create, class_payment: { bank_account_name: @class_payment.bank_account_name, bank_account_number: @class_payment.bank_account_number, bank_instruction: @class_payment.bank_instruction, bank_name: @class_payment.bank_name, cash_instruction: @class_payment.cash_instruction, classroom_id: @class_payment.classroom_id, trade_by_barter: @class_payment.trade_by_barter }
    end

    assert_redirected_to class_payment_path(assigns(:class_payment))
  end

  test "should show class_payment" do
    get :show, id: @class_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @class_payment
    assert_response :success
  end

  test "should update class_payment" do
    patch :update, id: @class_payment, class_payment: { bank_account_name: @class_payment.bank_account_name, bank_account_number: @class_payment.bank_account_number, bank_instruction: @class_payment.bank_instruction, bank_name: @class_payment.bank_name, cash_instruction: @class_payment.cash_instruction, classroom_id: @class_payment.classroom_id, trade_by_barter: @class_payment.trade_by_barter }
    assert_redirected_to class_payment_path(assigns(:class_payment))
  end

  test "should destroy class_payment" do
    assert_difference('ClassPayment.count', -1) do
      delete :destroy, id: @class_payment
    end

    assert_redirected_to class_payments_path
  end
end
