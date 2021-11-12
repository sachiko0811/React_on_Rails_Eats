import React from 'react';
import './App.css';
import { 
  BrowserRouter as Routes, Switch, Route, BrowserRouter,
} from 'react-router-dom';
// import { Switch } from 'react-router';

// components
import { Restaurants } from './containers/Restaurants.jsx';
import { Foods } from './containers/Foods.jsx';
import { Orders } from './containers/Orders.jsx';

function App() {
  return (
    <BrowserRouter>
    <Routes>
      <Switch>
        {/* // 店舗一覧ページ */}
        <Route
          exact
          path="/restaurants" //path="設定したいPATH"
        >
          <Restaurants />
        </Route>
        {/* // フード一覧ページ */}
        <Route
          exact
          path="/foods"
        >
          <Foods />
        </Route>
        {/* // 注文ページ */}
        <Route
          exact
          path="/orders"
        >
          <Orders />
        </Route>
        <Route
          exact
          path="/restaurants/:restaurantsId/foods"
          render={({ match }) => 
          <Foods 
            match={match}
          />
        }
        />
      </Switch>
    </Routes>
    </BrowserRouter>
  );
}

export default App;


// React Router -> <Router>で全体を囲む, <Switch>でルーティング先のコンポーネントを囲む
// ex => ページ共通のheaderやfooterがある場合には<Switch>の外に出しておく
// <Route>で実際に１ページへのルーティングを表す ... <Route>にpropsを渡すことでリクエストに対応して囲ったコンポーネントを描画 
// exact -> propsではデフォルトではfalseで、trueにするとexact={true}としなくても、PATHの完全一致の場合にのみコンポーネントをレンダリングする

// props: 親・子コンポーネント間でのデータの「受け渡し口」
// -> 親コンポーネントから渡したいデータをpropsという箱に入れ、子コンポーネントもpropsという箱を受け取れるようにし、子コンポーネントの中でpropsの箱の中のデータを参照

// export const ChildComponent = (props) => {
//   // props.idの方法で取得する方法
//   const hoge = () => { props.id }
// }

// export const ChildComponent = ({ id }) => {
//   // idと直接key名を指定してデータを参照する方法
//   const hoge = () => { id }
// }