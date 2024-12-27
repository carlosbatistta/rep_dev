import { OwnerRepo } from '@/components/OwnerRepo'

interface DataProps{
  id: number;
  name: string;
  full_name: string;
  owner:{
    login: string;
    id: number;
    avatar_url: string;
    url: string;
  }
}

//adiciona um delay na requisição
async function delayFetch(url: string, delay: number){
  await new Promise(resolve => setTimeout(resolve, delay))
  const response = await fetch(url);
  return response.json();
}

// async function getData(){
//   // https://api.github.com/users/devfraga/repos
//   const response = await fetch("https://api.github.com/users/devfraga/repos")

//   return response.json();
// }

async function getData(){
  const data = await delayFetch("https://api.github.com/users/carlosbatistta/repos", 0)
  return data;
}


export default async function Home(){
  const data: DataProps[] = await getData();

  return(
    <main>
      <h1>Página Home</h1>
      <span>Seja bem vindo a página home</span>
      <br/>

      <h3>Meus repositorios</h3>
      {data.map( (item) => (
        <div key={item.id}>
          <strong>Repositório: </strong> <a>{item.name}</a>
          <br/>
          <OwnerRepo
            avatar_url={item.owner.avatar_url}
            name={item.owner.login}
          />

          <br/>
        </div>
      ))}
    </main>
  )
}