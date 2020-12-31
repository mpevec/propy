export interface User {
  id: string;
  name: string;
}

export const toUser = ({ jwt }: { jwt: string }): User | null => {
  if (jwt) {
    const jwtAsArray = jwt.split('.');
    if (jwtAsArray[1]) {
      const payload = JSON.parse(atob(jwtAsArray[1]));
      return {
        id: payload.sub,
        name: payload.name,
      } as User;
    }
  }
  return null;
};
