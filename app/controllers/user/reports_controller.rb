class User::ReportsController < ApplicationController

  before_action :authenticate_user!

  # 新しい報告を作成
  def new
    @report = Report.new
    # ページのレイアウトを無効、単なるフォームを表示
    render :layout => false
  end

  def create
    # ユーザーが報告する対象の種類とIDを取得
    content_type = params[:report][:content_type]
    content_id = params[:report][:content_id]
    # 対象のコンテンツをデータベースから取得
    @content = content_type.constantize.find(content_id)
    # 対象のコンテンツが存在する場合
    if @content
      @report = Report.new(report_params)
      # 報告者と報告対象を取得
      @report.reporter = current_user
      @report.reported = @content.user
      # 報告をデータベースに保存
      if @report.save
        respond_to do |format|
          format.js { render "報告が完了しました"}
        end
      else
        respond_to do |format|
          format.js { render "報告に失敗しました"}
        end
      end
    end
  end

  private
    # コンテンツをデータベースから取得する
  def find_content(content_type, content_id)
    # content_typeを元に、クラス名の単語を大文字に変換して取得し、それをクラスに変換する
    content_class = content_type.classify.constantize
    # 取得したモデルクラスを使用して、idがcontent_idに一致するレコードを検索
    content_class.find_by(id: content_id)
  end

  def report_params
    params.require(:report).permit(:content_type, :content_id, :reason)
  end

end
