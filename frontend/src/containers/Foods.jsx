import React, { Fragment } from 'react';

export const Foods = ({ match }) => {
  return (
    <Fragment>
      フード一覧
      <p>
        restaurantsIdは {match.params.restaurantId}
です      </p>
    </Fragment>
  )
}

// React Routerの場合matchオブジェクトを受け取り、match.params.hogeのかたちでパラメーターを抽出できる