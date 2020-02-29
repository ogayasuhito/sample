

class SamplesController < ApplicationController
  include Common
    #１ページ当りの表示件数(メイン)
    MAXPAGESIZE = 3
    #１ページ当りの表示件数(管理者)
    MAXPAGELISTSIZE = 5

    # 初期表示
    # ページインデックスとカテゴリ絞り込みがしたい
    def index

      
      # 対象ページの取得
      @currentpagesize = 0
      startRecordIdx = 0
      if params[:currentpagesize].blank?
      else
        @currentpagesize = params[:currentpagesize].to_i
      end

      #カテゴリ指定がある場合
      @category = ""
      if params[:category].blank?
      else
        @category = params[:category]

      end

      # 対象開始レコードの算出
      if @currentpagesize > 0
        startRecordIdx = (@currentpagesize * MAXPAGESIZE)
      end
      


      
      #一覧部の抽出
      query = "
      SELECT
        Post.id
        , Post.title
        , Post.body
        , Post.img
        , GROUP_CONCAT(category) as category 
        , Post.created_at
        , Post.updated_at 
      FROM
        Post 
        LEFT OUTER JOIN category 
          ON Post.id = category.postid 
        where
        category.category LIKE ?
        group BY
          Post.id
          , Post.title
          , Post.body
          , Post.img
          , Post.created_at
          , Post.updated_at 
        order BY 
          updated_at desc
        limit ? , ?
        
"

      @posts = Post.find_by_sql([query, '%' + @category + '%' , startRecordIdx , MAXPAGESIZE])

      #最大件数
      querymax = "
      SELECT
        Post.id
      FROM
        Post 
        LEFT OUTER JOIN category 
          ON Post.id = category.postid 
        where
        category.category LIKE ?
        group BY
          Post.id
       
"
      maxcount = Post.find_by_sql([querymax, '%' + @category + '%']).count

      #最大ページ数の算出(切り捨て)
      @maxpagesize= (maxcount / MAXPAGESIZE).floor

      queryCategory = "
              SELECT
              category
              , count(*) as cnt 
            FROM
              category 
            group by
              category 
            ORDER BY
              category
            "

      @categorysdic = Category.find_by_sql([queryCategory])
    end
  
    # 詳細
    def detail
      @post = Post.find(params[:id])
      #画像保存
      File.binwrite("public/img/#{@post.id.to_s + ".jpg"}", @post.img)

    end
  
    # 管理者ログイン
    def adminLogin
      #@admin = Admin.all.limit(1)
      @admin = Admin.all.first
      @password = @admin.password
    end
  
    # 管理者パスワード変更
    def pwdChange
      @admin = Admin.all.first
      @password = @admin.password
    end

    # 管理者パスワード変更・登録
    def pwdChangeRegist

      @admin = Admin.first
      @admin.password = params[:passwordnew1]
      @admin.save

      redirect_to controller: 'samples', action: 'list'
    end

    # 記事一覧
    def list
      #セッション
      session[:adminpwd] = "pwd"


      #検索条件の取得
      if request.post?
        title = params[:title]
        category = params[:category]
        body = params[:body]
        sortclm = params[:sortclm]
        sort = params[:sort]

        @findCondtion = {title: title, category: category, body: body, sortclm:sortclm, sort:sort}
        session[:FindCondtion] = @findCondtion
      
      end

      #セッションから検索条件取得
      if session[:FindCondtion].blank?
        @findCondtion = {title: "", category: "", body: "", sortclm:"1", sort:"1"}
        session[:FindCondtion] = @findCondtion
      else
        @findCondtion = session[:FindCondtion]
      end

      #退避
      @title = @findCondtion[:title]
      @category = @findCondtion[:category]
      @body = @findCondtion[:body]
      @sortclm = @findCondtion[:sortclm]
      @sort = @findCondtion[:sort]
      

       # 対象ページの取得
       @currentpagesize = 0
       startRecordIdx = 0
       if params[:currentpagesize].blank?
       else
         @currentpagesize = params[:currentpagesize].to_i
       end
 
       # 対象開始レコードの算出
       if @currentpagesize > 0
         startRecordIdx = (@currentpagesize * MAXPAGELISTSIZE)
       end


      #一覧部の抽出
      query = "
      SELECT
        Post.id
        , Post.title
        , Post.body
        , Post.img
        , GROUP_CONCAT(category) as category 
        , Post.created_at
        , Post.updated_at 
      FROM
        Post 
        LEFT OUTER JOIN category 
          ON Post.id = category.postid 
      WHERE "

        
       # where条件
       where = " 1 = ? " #ダミー条件

       param_title = @title.to_s
       param_category = @category.to_s
       param_body = @body.to_s

       # title 全角ブランクを半角ブランクにする
       titleArray = param_title.gsub(/　/,' ').to_s.split(' ')

       if titleArray.count > 1 then
        titleArray.each_with_index do |val, i|
           if i == 0
             where = where + " AND ("
           else
             where = where + " OR "
           end
           #XSS対策
           where = where + " title LIKE  '%" + val.gsub("'","''") + "%' "

         end
         where = where + " ) "
       else
         where = where + " AND title LIKE  '%" + param_title.gsub("'","''") + "%' "
       end

        # category
        categoryArray = param_category.gsub(/　/,' ').to_s.split(' ')

        if categoryArray.count > 1 then
          categoryArray.each_with_index do |val, i|
            if i == 0
              where = where + " AND ("
            else
              where = where + " OR "
            end
            where = where + " category LIKE  '%" + val.gsub("'","''") + "%' "

          end
          where = where + " ) "
        else
          where = where + " AND category LIKE  '%" + param_category.gsub("'","''") + "%' "
        end

        # body
        bodyArray = param_body.gsub(/　/,' ').to_s.split(' ')

        if bodyArray.count > 1 then
          bodyArray.each_with_index do |val, i|
            if i == 0
              where = where + " AND ("
            else
              where = where + " OR "
            end
            where = where + " body LIKE  '%" + val.gsub("'","''") + "%' "
 
          end
          where = where + " ) "
        else
          where = where + " AND body LIKE  '%" + param_body.gsub("'","''") + "%' "
        end

        query = query + where
        
        query = query + "group BY
            Post.id
          , Post.title
          , Post.body
          , Post.img
          , Post.created_at
          , Post.updated_at "

        order = " order by "
        if @sortclm == "1"
          order = order + " created_at"
        else
          order = order + " updated_at"
        end

        if @sort == "1"
          order = order + " asc"
        else
          order = order + " desc"
        end
 
        query = query + order

  
        @posts = Post.find_by_sql([query + " limit ? , ? ", "1", startRecordIdx , MAXPAGELISTSIZE])

        #最大件数 #引数の１は、苦肉の策 パラメータがないと、ワイルドカードを含む場合エラーになる
        maxcount = Post.find_by_sql([query , "1"]).count
        
        #最大ページ数の算出(切り捨て)
        @maxpagesize= (maxcount / MAXPAGELISTSIZE).floor

        @startRowIdx = startRecordIdx
      
    end

    # 記事一覧削除
    def listDelete

      Post.where(id:params[:id]).delete_all
      Category.where(postid:params[:id]).delete_all

      redirect_to controller: 'samples', action: 'list'
    end

    # 記事一覧登録・更新画面の表示
    def listRegist
      if params[:id].blank?
        @post = Post.new
        @category = ''
      else
        @post = Post.find(params[:id])
        @category = ''

        catelist = Category.where(postid:params[:id])
        catelist.each_with_index do |val, i|
          if i == 0
            @category = val.category
          else
            @category = @category + ',' + val.category
          end
          
        end

        
      end
      File.binwrite("public/img/#{@post.id.to_s + ".jpg"}", @post.img)

    end

    # 記事一覧登録・更新
    def listRegistd

      #新規か更新か
      if params[:id].blank?
        @post = Post.new
      else
        @post = Post.find(params[:id])
      end
      
      #postの登録
      @post.title = params[:txtTitle]
      @post.body = params[:txtBody]
      
      if params[:imgdata].blank?
      else
        imagedata = params[:imgdata].read
        @post.img = imagedata
      end
      @post.save

      #カテゴリの登録
      Category.where(postid:params[:id]).delete_all

      str = params[:txtCategory]

      array = str.split(",")
      array.each do |val|
        category = Category.new
        category.postid = @post.id
        category.category = val
        category.save
      end

      redirect_to controller: 'samples', action: 'list'


    end

end